import '../database/database_helper.dart';
import '../model/order.dart';

class ReportRepository {
  Future<List<Order>> getAllReports()async{
    return await DatabaseHelper.db.getAllOrders();
  }
}