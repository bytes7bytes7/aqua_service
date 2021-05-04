import 'client_bloc.dart';
import 'fabric_bloc.dart';
import 'report_bloc.dart';
import 'order_bloc.dart';
import '../repository/repository.dart';

class Bloc {
  Bloc._privateConstructor();

  static final Bloc bloc = Bloc._privateConstructor();

  static ClientBloc _clientBloc;
  static FabricBloc _fabricBloc;
  static OrderBloc _orderBloc;
  static ReportBloc _reportBloc;

  ClientBloc get clientBloc {
    if (_clientBloc != null) return _clientBloc;
    _clientBloc = ClientBloc(Repository.clientRepository);
    return _clientBloc;
  }

  FabricBloc get fabricBloc {
    if (_fabricBloc != null) return _fabricBloc;
    _fabricBloc = FabricBloc(Repository.fabricRepository);
    return _fabricBloc;
  }

  OrderBloc get orderBloc {
    if (_orderBloc != null) return _orderBloc;
    _orderBloc = OrderBloc(Repository.orderRepository);
    return _orderBloc;
  }

  ReportBloc get reportBloc {
    if (_reportBloc != null) return _reportBloc;
    _reportBloc = ReportBloc(Repository.reportRepository);
    return _reportBloc;
  }
}
