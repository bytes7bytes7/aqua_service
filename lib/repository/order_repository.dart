import '../test_data.dart';
import '../model/order.dart';

class OrderRepository {
  Future<List<Order>> getAllOrders() async {
    await Future.delayed(const Duration(seconds: 2));
    return testOrders;
  }
}
