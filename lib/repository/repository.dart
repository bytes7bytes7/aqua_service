import '../repository/clients_repository.dart';
import '../repository/fabric_repository.dart';
import '../repository/order_repository.dart';

class Repository{

  static ClientRepository clientRepository = ClientRepository();
  static FabricRepository fabricRepository = FabricRepository();
  static OrderRepository orderRepository = OrderRepository();

}