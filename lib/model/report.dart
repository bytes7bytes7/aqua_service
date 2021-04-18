import 'package:meta/meta.dart';

class Report {
  Report({
    @required this.timePeriod,
    @required this.profit,
    @required this.date,
  });

  final String timePeriod;
  final double profit;
  final String date;
}
