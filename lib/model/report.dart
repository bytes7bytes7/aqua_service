import 'package:meta/meta.dart';

class Report {
  Report({
    this.id,
    @required this.timePeriod,
    @required this.profit,
    @required this.date,
  });

  int id;
  String timePeriod;
  double profit;
  String date;
}
