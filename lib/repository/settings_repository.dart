import '../model/client.dart';
import '../model/fabric.dart';
import '../model/order.dart';
import '../model/settings.dart';
import '../database/database_helper.dart';

class SettingsRepository {
  Future<Settings> getSettings() async {
    return await DatabaseHelper.db.getSettings();
  }

  Future updateSettings(Settings settings) async {
    await DatabaseHelper.db.updateSettings(settings);
  }

  Future clearDatabase(List<String> dbName) async {
    for (String name in dbName) await DatabaseHelper.db.dropBD(name);
  }

  Future importExcel(List<Client> clients, List<Fabric> fabrics,
      List<Order> orders, Settings settings) async {
    await DatabaseHelper.db.deleteAllClients();
    await DatabaseHelper.db.deleteAllOrders();
    await DatabaseHelper.db.deleteAllFabrics();
    await DatabaseHelper.db.addAllClients(clients);
    await DatabaseHelper.db.addAllFabrics(fabrics);
    await DatabaseHelper.db.addAllOrders(orders);
  }
}
