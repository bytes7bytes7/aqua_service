import 'dart:async';

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

  void loadAllReports(){
    _reportStreamController.sink.add(ReportState._reportLoading());
    _repository.getAllReports().then((reportList) {
      reportList.sort((a,b) => a.date.compareTo(b.date));
      if(!_reportStreamController.isClosed)
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

class ReportLoadingState extends ReportState{}

class ReportDataState extends ReportState {
  ReportDataState(this.reports);
  final List<Report> reports;
}