import 'dart:async';

import '../model/order.dart';
import '../repository/order_repository.dart';

class OrderBloc{
  OrderBloc(this._repository);

  final OrderRepository _repository;
  final _orderStreamController = StreamController<OrderState>();

  Stream<OrderState> get order => _orderStreamController.stream;

  void dispose(){
    _orderStreamController.close();
  }

  void getAllOrders(){
    _orderStreamController.sink.add(OrderState._orderLoading());
    _repository.getAllOrders().then((orderList) {
      _orderStreamController.sink.add(OrderState._orderData(orderList));
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