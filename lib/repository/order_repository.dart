import '../test_data.dart';
import 'repository.dart';
import '../model/order.dart';

class OrderRepository extends Repository {
  Future<List<Order>> getAllOrders() async {
    await Future.delayed(const Duration(seconds: 2));
    return testOrders;
  }
}
