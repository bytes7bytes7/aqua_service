import 'package:aqua_service/screens/order_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'order_short_info_screen.dart';
import 'widgets/app_header.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({
    Key key,
    @required this.updateDate,
  }) : super(key: key);
  final Function updateDate;

  final DateTime _currentDate = DateTime(2021, 5, 6);

  final ValueNotifier<bool> _calendarNotifier = ValueNotifier(false);
  final ValueNotifier<DateTime> _currentDate2Notifier =
      ValueNotifier(DateTime(2021, 5, 6));
  final ValueNotifier<String> _currentMonthNotifier =
      ValueNotifier(DateFormat.yMMM().format(DateTime(2021, 5, 6)));
  final ValueNotifier<DateTime> _targetDateTimeNotifier =
      ValueNotifier(DateTime(2021, 5, 6));

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2021, 5, 10): [
        Event(
          date: DateTime(2021, 5, 10),
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
          date: DateTime(2021, 5, 10),
          title: 'Event 2',
          icon: _EventIcon(),
        ),
        Event(
          date: DateTime(2021, 5, 10),
          title: 'Event 3',
          icon: _EventIcon(),
        ),
      ],
    },
  );

  void init() {
    _markedDateMap.add(
        DateTime(2021, 5, 25),
        Event(
          date: DateTime(2021, 5, 25),
          title: 'Event 5',
          icon: _EventIcon(),
        ));

    _markedDateMap.add(
        DateTime(2021, 5, 10),
        Event(
          date: DateTime(2021, 5, 10),
          title: 'Event 4',
          icon: _EventIcon(),
        ));

    _markedDateMap.addAll(new DateTime(2021, 5, 11), [
      Event(
        date: DateTime(2021, 5, 11),
        title: 'Event 1',
        icon: _EventIcon(),
      ),
      Event(
        date: DateTime(2021, 5, 11),
        title: 'Event 2',
        icon: _EventIcon(),
      ),
      Event(
        date: DateTime(2021, 5, 11),
        title: 'Event 3',
        icon: _EventIcon(),
      ),
    ]);
  }

  void _updateCalendar() => _calendarNotifier.value = !_calendarNotifier.value;

  void _updateCurrentDate2(DateTime dateTime) {
    _currentDate2Notifier.value = dateTime;
    _updateCalendar();
    if (updateDate != null) updateDate(dateTime);
  }

  void _updateCurrentMonth(String month) {
    _currentMonthNotifier.value = month;
    _updateCalendar();
  }

  void _updateTargetDateTime(DateTime dateTime) {
    _targetDateTimeNotifier.value = dateTime;
    _updateCalendar();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      appBar: AppHeader(
        title: 'Календарь',
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ValueListenableBuilder(
                    valueListenable: _calendarNotifier,
                    builder: (BuildContext context, bool b, Widget child) {
                      return CalendarCarousel<Event>(
                        customGridViewPhysics: NeverScrollableScrollPhysics(),
                        locale: "RU",
                        firstDayOfWeek: 1,
                        height: 420.0,
                        weekDayMargin: const EdgeInsets.only(bottom: 15),
                        markedDatesMap: _markedDateMap,
                        selectedDateTime: _currentDate2Notifier.value,
                        targetDateTime: _targetDateTimeNotifier.value,
                        minSelectedDate:
                            _currentDate.subtract(Duration(days: 360)),
                        maxSelectedDate:
                            _currentDate.add(Duration(days: 360)),
                        daysHaveCircularBorder: true,
                        showOnlyCurrentMonthDate: true,
                        showHeader: true,
                        weekFormat: false,
                        iconColor: Theme.of(context).focusColor,
                        headerTextStyle:
                            Theme.of(context).textTheme.headline2,
                        thisMonthDayBorderColor: Colors.transparent,
                        selectedDayBorderColor: Colors.transparent,
                        selectedDayButtonColor: Theme.of(context).cardColor,
                        todayBorderColor: Theme.of(context).cardColor,
                        todayButtonColor: Colors.transparent,
                        daysTextStyle: Theme.of(context).textTheme.bodyText1,
                        weekdayTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).focusColor),
                        todayTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).cardColor),
                        markedDateCustomTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).accentColor),
                        selectedDayTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).focusColor),
                        inactiveDaysTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).disabledColor),
                        weekendTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).cardColor),
                        prevDaysTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).disabledColor),
                        nextDaysTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).disabledColor),
                        onDayPressed: (date, events) {
                          _updateCurrentDate2(date);
                          events.forEach((event) => print(event.title));
                        },
                        onCalendarChanged: (DateTime date) {
                          _updateTargetDateTime(date);
                          _updateCurrentMonth(DateFormat.yMMM()
                              .format(_targetDateTimeNotifier.value));
                        },
                        onDayLongPressed: (DateTime date) {
                          print('long pressed date $date');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
            DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.95,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).cardColor,
                  ),
                  // child: OrderShortInfoScreen(
                  //   order: null,
                  // ),
                );
              },
            ),
        ],
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
