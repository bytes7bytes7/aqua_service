import 'repository.dart';
import '../test_data.dart';
import '../model/client.dart';

class ClientRepository extends Repository {
  Future<List<Client>> getAllClients()async{
    await Future.delayed(const Duration(seconds: 1));
    return testClients;
  }
}