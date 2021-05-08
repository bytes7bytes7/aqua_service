import 'package:aqua_service/bloc/order_bloc.dart';
import 'package:aqua_service/model/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'order_short_info_screen.dart';
import 'order_info_screen.dart';
import '../bloc/bloc.dart';
import 'widgets/app_header.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({
    Key key,
    @required this.updateDate,
  }) : super(key: key);
  final Function updateDate;

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Календарь',
      ),
      body: StreamBuilder(
        stream: Bloc.bloc.orderBloc.order,
        initialData: OrderInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is OrderInitState) {
            Bloc.bloc.orderBloc.loadAllOrders();
            return SizedBox.shrink();
          } else if (snapshot.data is OrderLoadingState) {
            return _buildLoading();
          } else if (snapshot.data is OrderDataState) {
            OrderDataState state = snapshot.data;
            if (state.orders.length > 0)
              return CalendarContent(
                orders: state.orders,
                updateDate: widget.updateDate,
              );
            else
              return Center(
                child: Text(
                  'Пусто',
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
          } else {
            return _buildError();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingCircle(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка',
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 20),
          RectButton(
            text: 'Обновить',
            onPressed: () {
              Bloc.bloc.orderBloc.loadAllOrders();
            },
          ),
        ],
      ),
    );
  }
}

class CalendarContent extends StatefulWidget {
  CalendarContent({
    @required this.orders,
    this.updateDate,
  });

  final List<Order> orders;
  final Function updateDate;

  @override
  _CalendarContentState createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  final DateTime _currentDate = DateTime.now();
  final ValueNotifier<bool> _calendarNotifier = ValueNotifier(false);
  final ValueNotifier<DateTime> _currentDate2Notifier =
      ValueNotifier(DateTime.now());
  final ValueNotifier<String> _currentMonthNotifier =
      ValueNotifier(DateFormat.yMMM().format(DateTime.now()));
  final ValueNotifier<DateTime> _targetDateTimeNotifier =
      ValueNotifier(DateTime(2021, 5, 6));

  @override
  void dispose() {
    if (widget.updateDate == null) Bloc.bloc.orderBloc.dispose();
    super.dispose();
  }

  void _updateCalendar() => _calendarNotifier.value = !_calendarNotifier.value;

  void _updateCurrentDate2(DateTime dateTime) {
    _currentDate2Notifier.value = dateTime;
    _updateCalendar();
    if (widget.updateDate != null) widget.updateDate(dateTime);
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
    EventList<Event> _markedDateMap = EventList<Event>(
      events: Map<DateTime, List<Event>>.fromIterables(
        widget.orders.map((e) => DateFormat("dd.MM.yyyy").parse(e.date)),
        widget.orders.map(
          (e) => [
            Event(
              date: DateFormat("dd.MM.yyyy").parse(e.date),
              title: '${(e.client.name != '') ? (e.client.name + ' ') : ''}' +
                  '${e.client.surname ?? ''}'.replaceAll(RegExp(r"\s+"), ""),
              icon: _EventIcon(),
            ),
          ],
        ),
      ),
    );
    return Stack(
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
                      maxSelectedDate: _currentDate.add(Duration(days: 360)),
                      daysHaveCircularBorder: true,
                      showOnlyCurrentMonthDate: true,
                      showHeader: true,
                      weekFormat: false,
                      iconColor: Theme.of(context).focusColor,
                      headerTextStyle: Theme.of(context).textTheme.headline2,
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
        SizedBox.expand(
          child: DraggableScrollableSheet(
            expand: true,
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: Theme.of(context).focusColor,
                  ),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _calendarNotifier,
                  builder: (BuildContext context, _, Widget child) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: widget.orders.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        Iterable<int> bytes;
                        if (index == 0)
                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Заказы',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).focusColor,
                                  thickness: 1,
                                  height: 0,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          );
                        else
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            width: double.infinity,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.0,
                                  backgroundColor: Theme.of(context).focusColor,
                                  child: (bytes != null)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: MemoryImage(bytes),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          color: Theme.of(context).cardColor,
                                        ),
                                ),
                                SizedBox(width: 14.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${(widget.orders[index - 1].client.name != '') ? (widget.orders[index - 1].client.name + ' ') : ''}' +
                                          '${widget.orders[index - 1].client.surname ?? ''}'
                                              .replaceAll(RegExp(r"\s+"), ""),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      widget.orders[index - 1].client.city,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  (widget.orders[index - 1].price != null &&
                                          widget.orders[index - 1].expenses !=
                                              null)
                                      ? (widget.orders[index - 1].price -
                                              widget.orders[index - 1].expenses)
                                          .toString()
                                      : '0.0',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
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
