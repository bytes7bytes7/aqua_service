import 'dart:async';

import '../model/order.dart';
import '../repository/order_repository.dart';

class OrderBloc{
  OrderBloc(this._repository);

  final OrderRepository _repository;
  static StreamController _orderStreamController;

  Stream<OrderState> get order {
    if (_orderStreamController == null || _orderStreamController.isClosed)
      _orderStreamController = StreamController<OrderState>();
    return _orderStreamController.stream;
  }

  void dispose(){
    _orderStreamController.close();
  }

  void loadAllOrders(){
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.getAllOrders().then((orderList) {
      orderList.sort((a,b) => a.date.compareTo(b.date));
      if(!_orderStreamController.isClosed)
      _orderStreamController.sink.add(OrderState._orderData(orderList));
    });
  }
  void deleteOrder(int id) {
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.deleteOrder(id).then((value) {
      loadAllOrders();
    });
  }

  void updateOrder(Order order){
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.updateOrder(order).then((value) {
      loadAllOrders();
    });
  }

  void addOrder(Order order){
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.addOrder(order).then((value) {
      loadAllOrders();
    });
  }
}

class OrderState{
  OrderState();
  factory OrderState._orderData(List<Order> orders) = OrderDataState;
  factory OrderState._orderLoading() = OrderLoadingState;
}

class OrderInitState extends OrderState{}

class OrderLoadingState extends OrderState{}

class OrderDataState extends OrderState{
  OrderDataState(this.orders);
  final List<Order> orders;
}