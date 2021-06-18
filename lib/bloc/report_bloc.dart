import 'dart:async';

import '../model/fabric.dart';
import '../model/report.dart';
import '../constants.dart';
import '../repository/report_repository.dart';

class ReportBloc {
  ReportBloc(this._repository);

  final ReportRepository _repository;
  static StreamController _reportStreamController;

  Stream<ReportState> get report {
    if (_reportStreamController == null || _reportStreamController.isClosed)
      _reportStreamController = StreamController<ReportState>();
    return _reportStreamController.stream;
  }

  void dispose() {
    _reportStreamController.close();
  }

  void loadAllReports() async {
    _reportStreamController.sink.add(ReportState._reportLoading());
    _repository.getAllReports().then((orderList) async {
      Map<String, List<double>> months = {};
      Map<String, List<double>> years = {};
      DateTime today = DateTime.now();
      orderList.forEach((element) async {
        if (element.done) {
          List<String> date = element.date.split('.');
          String year = date[0], month = date[1];
          years.putIfAbsent(year, () => [0.0, 0.0]);
          double profit = element.price;
          if(element.fabrics != null && element.fabrics.length>0){
            for(int i =0;i<element.fabrics.length;i++){
              profit+=element.fabrics[i].retailPrice - element.fabrics[i].purchasePrice;
            }
          }
          if (element.expenses != null) {
            profit -= element.expenses;
            years[year][1] += element.expenses;
          }
          years[year][0] += profit;
          if (year == today.year.toString()) {
            months.putIfAbsent(month, () => [0.0, 0.0]);
            months[month][0] += profit;
            if (element.expenses != null) {
              months[month][1] += element.expenses;
            }
          }
        }
      });
      List<Report> reportList = [];
      int currentId = 1;
      months.forEach((key, value) {
        reportList.add(Report(
          id: currentId,
          profit: value[0],
          expenses: value[1],
          timePeriod: ConstData.monthsNames[key],
        ));
        currentId++;
      });
      years.forEach((key, value) {
        reportList.add(Report(
          id: currentId,
          profit: value[0],
          expenses: value[1],
          timePeriod: key + ' год',
        ));
        currentId++;
      });
      if (!_reportStreamController.isClosed)
        _reportStreamController.sink.add(ReportState._reportData(reportList));
    }).onError((error, stackTrace) {
      if (!_reportStreamController.isClosed)
        _reportStreamController.sink
            .add(ReportState._reportError(error, stackTrace));
    });
  }
}

class ReportState {
  ReportState();

  factory ReportState._reportData(List<Report> reports) = ReportDataState;

  factory ReportState._reportLoading() = ReportLoadingState;

  factory ReportState._reportError(Error error, StackTrace stackTrace) =
      ReportErrorState;
}

class ReportInitState extends ReportState {}

class ReportLoadingState extends ReportState {}

class ReportErrorState extends ReportState {
  ReportErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class ReportDataState extends ReportState {
  ReportDataState(this.reports);

  final List<Report> reports;
}
