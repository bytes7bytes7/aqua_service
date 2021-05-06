import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'widgets/app_header.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime(2021, 6, 5);
  DateTime _currentDate2 = DateTime(2019, 2, 3);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2021, 6, 5));
  DateTime _targetDateTime = DateTime(2019, 2, 3);

  //  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];

  EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2019, 2, 10): [
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _EventIcon(),
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _EventIcon(),
        ),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _EventIcon(),
        ),
      ],
    },
  );

  @override
  void initState() {
    _markedDateMap.add(
        DateTime(2019, 2, 25),
        Event(
          date: DateTime(2019, 2, 25),
          title: 'Event 5',
          icon: _EventIcon(),
        ));

    _markedDateMap.add(
        DateTime(2019, 2, 10),
        Event(
          date: DateTime(2019, 2, 10),
          title: 'Event 4',
          icon: _EventIcon(),
        ));

    _markedDateMap.addAll(new DateTime(2019, 2, 11), [
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _EventIcon(),
      ),
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _EventIcon(),
      ),
      Event(
        date: DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _EventIcon(),
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Календарь',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 30.0,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left_outlined,
                      color: Theme.of(context).focusColor,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month - 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  ),
                  Text(
                    _currentMonth,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: Theme.of(context).focusColor,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                            _targetDateTime.year, _targetDateTime.month + 1);
                        _currentMonth =
                            DateFormat.yMMM().format(_targetDateTime);
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarCarousel<Event>(
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                firstDayOfWeek: 1,
                height: 420.0,
                markedDatesMap: _markedDateMap,
                selectedDateTime: _currentDate2,
                targetDateTime: _targetDateTime,
                minSelectedDate: _currentDate.subtract(Duration(days: 360)),
                maxSelectedDate: _currentDate.add(Duration(days: 360)),
                daysHaveCircularBorder: false,
                showOnlyCurrentMonthDate: false,
                showHeader: false,
                weekFormat: false,
                thisMonthDayBorderColor: Colors.transparent,
                selectedDayBorderColor: Colors.transparent,
                selectedDayButtonColor: Theme.of(context).cardColor,
                todayBorderColor: Theme.of(context).cardColor,
                todayButtonColor: Colors.transparent,
                todayTextStyle: TextStyle(
                  color: Theme.of(context).cardColor,
                ),
                markedDateCustomTextStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
                selectedDayTextStyle: TextStyle(
                  color: Theme.of(context).focusColor,
                ),
                inactiveDaysTextStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
                weekendTextStyle: TextStyle(
                  color: Theme.of(context).cardColor,
                ),
                prevDaysTextStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
                nextDaysTextStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
                onDayPressed: (date, events) {
                  this.setState(() => _currentDate2 = date);
                  events.forEach((event) => print(event.title));
                },
                onCalendarChanged: (DateTime date) {
                  this.setState(() {
                    _targetDateTime = date;
                    _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                  });
                },
                onDayLongPressed: (DateTime date) {
                  print('long pressed date $date');
                },
              ),
            ), //
          ],
        ),
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.all(Radius.circular(1000)),
          border: Border.all(color: Theme.of(context).accentColor, width: 2.0)),
      child: Icon(
        Icons.person,
        color: Theme.of(context).focusColor,
      ),
    );
  }
}
