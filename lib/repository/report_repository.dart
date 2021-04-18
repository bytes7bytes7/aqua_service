import 'repository.dart';
import '../test_data.dart';
import '../model/report.dart';

class ReportRepository extends Repository {
  Future<List<Report>> getAllReports()async{
    await Future.delayed(const Duration(seconds: 1));
    return testReports;
  }
}