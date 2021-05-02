import '../database/database_helper.dart';
import '../model/client.dart';

class ClientRepository {
  Future<List<Client>> getAllClients() async {
    return await DatabaseHelper.db.getAllClients();
  }

  Future<Client> getClient(int id)async{
    return await DatabaseHelper.db.getClient(id);
  }

  Future deleteClient(int id) async{
    await DatabaseHelper.db.deleteClient(id);
  }

  Future updateClient(Client client)async{
    await DatabaseHelper.db.updateClient(client);
  }

  Future addClient(Client client)async{
    await DatabaseHelper.db.addClient(client);
  }
}
