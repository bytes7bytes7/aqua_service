import 'dart:async';

import '../model/order.dart';
import '../repository/order_repository.dart';

class OrderBloc {
  OrderBloc(this._repository);

  final OrderRepository _repository;
  static StreamController _orderStreamController;

  Stream<OrderState> get order {
    if (_orderStreamController == null || _orderStreamController.isClosed)
      _orderStreamController = StreamController<OrderState>.broadcast();
    return _orderStreamController.stream;
  }

  void dispose() {
    _orderStreamController.close();
  }

  void loadAllOrders() async {
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.getAllOrders().then((orderList) async {
      orderList.sort((a, b) => a.date.compareTo(b.date));
      for (int i = 0; i < orderList.length; i++) {
        List<String> date = orderList[i].date.split('.');
        String year = date[0], month = date[1], day = date[2];
        orderList[i].date = day + '.' + month + '.' + year;
      }
      if (!_orderStreamController.isClosed)
        _orderStreamController.sink.add(OrderState._orderData(orderList));
    }).onError((error, stackTrace) {
      if (!_orderStreamController.isClosed)
        _orderStreamController.sink.add(OrderState._orderError());
    });
  }

  void deleteOrder(int id) async {
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.deleteOrder(id).then((value) {
      loadAllOrders();
    });
  }

  void updateOrder(Order order) async {
    _orderStreamController.sink.add(OrderState._orderLoading());
    Order newOrder = Order.from(order);
    List<String> date = newOrder.date.split('.');
    String day = date[0], month = date[1], year = date[2];
    newOrder.date = year + '.' + month + '.' + day;
    _repository.updateOrder(newOrder).then((value) {
      loadAllOrders();
    });
  }

  Future addOrder(Order order) async {
    _orderStreamController.sink.add(OrderState._orderLoading());
    Order newOrder = Order.from(order);
    List<String> date = newOrder.date.split('.');
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

  factory OrderState._orderData(List<Order> orders) = OrderDataState;

  factory OrderState._orderLoading() = OrderLoadingState;

  factory OrderState._orderError() = OrderErrorState;
}

class OrderInitState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderErrorState extends OrderState {}

class OrderDataState extends OrderState {
  OrderDataState(this.orders);

  final List<Order> orders;
}
