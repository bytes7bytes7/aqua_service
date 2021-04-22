import '../database/client_database.dart';
import '../model/client.dart';

class ClientRepository {
  Future<List<Client>> getAllClients() async {
    return await ClientDatabase.db.getAllClients();
  }
}
