import 'dart:async';

import '../model/client.dart';
import '../model/order.dart';
import '../repository/order_repository.dart';

class OrderBloc {
  OrderBloc(this._repository);

  final OrderRepository _repository;
  // ignore: close_sinks
  static StreamController? _orderStreamController;

  Stream<OrderState> get order {
    if (_orderStreamController == null || _orderStreamController!.isClosed)
      _orderStreamController = StreamController<OrderState>.broadcast();
    return _orderStreamController!.stream as Stream<OrderState>;
  }

  void dispose() {
    if(_orderStreamController!= null && !_orderStreamController!.isClosed) {
      _orderStreamController!.close();
    }
  }

  void loadAllOrders() async {
    _orderStreamController!.sink.add(OrderState._orderLoading());
    _repository.getAllOrders().then((orderList) async {
      // orderList.sort((a, b) => b.date!.compareTo(a.date!));

      Map<Client, List<Order>> map = {};
      orderList.forEach((order) {
        if(map.containsKey(order.client)){
          map[order.client]!.add(order);
        }else{
          map[order.client!] = <Order>[order];
        }
      });

      // reverse date to DD.MM.YYYY
      for (int i = 0; i < orderList.length; i++) {
        List<String> date = orderList[i].date!.split('.');
        String year = date[0], month = date[1], day = date[2];
        orderList[i].date = day + '.' + month + '.' + year;
      }

      if (!_orderStreamController!.isClosed)
        _orderStreamController!.sink.add(OrderState._orderData(map));
    }).onError((dynamic error, stackTrace) {
      if (!_orderStreamController!.isClosed)
        _orderStreamController!.sink.add(OrderState._orderError(error, stackTrace));
    });
  }

  void deleteOrder(int id) async {
    _orderStreamController!.sink.add(OrderState._orderLoading());
    _repository.deleteOrder(id).then((value) {
      loadAllOrders();
    });
  }

  void updateOrder(Order order) async {
    _orderStreamController!.sink.add(OrderState._orderLoading());
    Order newOrder = Order.from(order);
    List<String> date = newOrder.date!.split('.');
    String day = date[0], month = date[1], year = date[2];
    newOrder.date = year + '.' + month + '.' + day;
    _repository.updateOrder(newOrder).then((value) {
      loadAllOrders();
    });
  }

  Future addOrder(Order order) async {
    _orderStreamController!.sink.add(OrderState._orderLoading());
    Order newOrder = Order.from(order);
    List<String> date = newOrder.date!.split('.');
    String day = date[0], month = date[1], year = date[2];
    newOrder.date = year + '.' + month + '.' + day;
    order.id = await _repository.addOrder(newOrder).then((value) {
      loadAllOrders();
      return newOrder.id;
    });
  }
}

class OrderState {
  OrderState();

  factory OrderState._orderData(Map<Client, List<Order>> orderPack) = OrderDataState;

  factory OrderState._orderLoading() = OrderLoadingState;

  factory OrderState._orderError(Error error, StackTrace stackTrace) = OrderErrorState;
}

class OrderInitState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderErrorState extends OrderState {
  OrderErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class OrderDataState extends OrderState {
  OrderDataState(this.orderPack);

  final Map<Client, List<Order>> orderPack;
}
