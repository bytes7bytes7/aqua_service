import 'dart:async';

import 'package:aqua_service/constants.dart';

import '../model/report.dart';
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
      Map<String, List<double>> months={};
      Map<String, List<double>> years={};
      DateTime today = DateTime.now();
      orderList.forEach((element) {
        if(element.done) {
          List<String> date = element.date.split('.');
          String year = date[0],
              month = date[1];
          double profit = element.price - element.expenses;
          years.putIfAbsent(year, () => [0.0, 0.0]);
          years[year][0] += profit;
          years[year][1] += element.expenses;
          if (year == today.year.toString()) {
            months.putIfAbsent(month, () => [0.0, 0.0]);
            months[month][0] += profit;
            months[month][1] += element.expenses;
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
          timePeriod: key+' год',
        ));
        currentId++;
      });
      if (!_reportStreamController.isClosed)
        _reportStreamController.sink.add(ReportState._reportData(reportList));
    });
  }
}

class ReportState {
  ReportState();

  factory ReportState._reportData(List<Report> reports) = ReportDataState;

  factory ReportState._reportLoading() = ReportLoadingState;
}

class ReportInitState extends ReportState {}

class ReportLoadingState extends ReportState {}

class ReportDataState extends ReportState {
  ReportDataState(this.reports);

  final List<Report> reports;
}
