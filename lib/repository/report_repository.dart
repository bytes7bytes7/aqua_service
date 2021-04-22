import '../test_data.dart';
import '../model/report.dart';

class ReportRepository {
  Future<List<Report>> getAllReports()async{
    await Future.delayed(const Duration(seconds: 1));
    return testReports;
  }
}