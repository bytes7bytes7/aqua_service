import '../database/database_helper.dart';
import '../model/settings.dart';

class SettingsRepository {
  Future<Settings> getSettings() async {
    return await DatabaseHelper.db.getSettings();
  }

  Future updateSettings(Settings settings) async {
    await DatabaseHelper.db.updateSettings(settings);
  }

  Future clearDatabase(List<String> dbName)async{
    for (String name in dbName)
      await DatabaseHelper.db.dropBD(name);
  }
}
