import '../repository/report_repository.dart';
import '../repository/client_repository.dart';
import '../repository/fabric_repository.dart';
import '../repository/order_repository.dart';

abstract class Repository {
  static ClientRepository clientRepository = ClientRepository();
  static FabricRepository fabricRepository = FabricRepository();
  static OrderRepository orderRepository = OrderRepository();
  static ReportRepository reportRepository = ReportRepository();
}
