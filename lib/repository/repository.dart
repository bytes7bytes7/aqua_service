import 'report_repository.dart';
import 'client_repository.dart';
import 'fabric_repository.dart';
import 'order_repository.dart';
import 'settings_repository.dart';

abstract class Repository {
  static ClientRepository clientRepository = ClientRepository();
  static FabricRepository fabricRepository = FabricRepository();
  static OrderRepository orderRepository = OrderRepository();
  static ReportRepository reportRepository = ReportRepository();
  static SettingsRepository settingsRepository = SettingsRepository();
}
