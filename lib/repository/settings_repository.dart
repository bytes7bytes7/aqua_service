import 'package:aqua_service/bloc/bloc.dart';

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
    Bloc.bloc.dispose();
    for (String name in dbName) {
      await DatabaseHelper.db.dropDB(name);
    }
  }

  Future importExcel(List<Client> clients, List<Fabric> fabrics,
      List<Order> orders, Settings settings) async {
    await DatabaseHelper.db.deleteAllClients();
    await DatabaseHelper.db.deleteAllOrders();
    await DatabaseHelper.db.deleteAllFabrics();
    if (clients.length > 0) {
      await DatabaseHelper.db.addAllClients(clients);
    }
    if (fabrics.length > 0) {
      await DatabaseHelper.db.addAllFabrics(fabrics);
    }
    if (orders.length > 0) {
      await DatabaseHelper.db.addAllOrders(orders);
    }
    if (settings.id != null) {
      await DatabaseHelper.db.updateSettings(settings);
    }
  }
}
