import 'package:aqua_service/repository/repository.dart';
import 'package:aqua_service/test_data.dart';
import '../model/client.dart';

class ClientRepository extends Repository {
  Future<Client> getClient()async{
    await Future.delayed(const Duration(seconds: 2));
    return Client(name: 'John',surname: 'Smith',city: 'New York');
  }

  Future<List<Client>> getAllClients()async{
    await Future.delayed(const Duration(seconds: 1));
    return testClients;
  }
}