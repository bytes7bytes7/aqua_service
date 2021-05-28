import '../database/database_helper.dart';
import '../model/settings.dart';

class SettingsRepository {
  Future<Settings> getSettings() async {
    return await DatabaseHelper.db.getSettings();
  }

  Future updateSettings(Settings settings) async {
    await DatabaseHelper.db.updateSettings(settings);
  }

  Future deleteAllData()async{
    await DatabaseHelper.db.dropBD();
  }
}
