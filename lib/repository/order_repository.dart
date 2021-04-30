import '../database/database_helper.dart';
import '../model/order.dart';

class OrderRepository {
  Future<List<Order>> getAllOrders() async {
    return DatabaseHelper.db.getAllOrders();
  }

  Future deleteOrder(int id) async{
    await DatabaseHelper.db.deleteOrder(id);
  }

  Future updateOrder(Order order)async{
    await DatabaseHelper.db.updateOrder(order);
  }

  Future addOrder(Order order)async{
    await DatabaseHelper.db.addOrder(order);
  }
}
