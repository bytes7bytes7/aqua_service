import '../model/order.dart';
import '../database/database_helper.dart';

class ReportRepository {
  Future<List<Order>> getAllReports()async{
    return await DatabaseHelper.db.getAllOrders();
  }
}