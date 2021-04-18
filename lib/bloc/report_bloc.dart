import 'dart:async';

import '../model/report.dart';
import '../repository/report_repository.dart';

class ReportBloc {
  ReportBloc(this._repository);

  final ReportRepository _repository;
  final _reportStreamController = StreamController<ReportState>();

  Stream<ReportState> get report => _reportStreamController.stream;

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