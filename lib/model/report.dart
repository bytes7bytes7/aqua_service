import 'package:meta/meta.dart';

class Report {
  Report({
    this.id,
    @required this.timePeriod,
    @required this.profit,
    @required this.expenses,
  });

  int id;
  String timePeriod;
  double profit;
  double expenses;
}
