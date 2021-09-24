import 'dart:io';
import 'dart:typed_data';
import 'package:aqua_service/services/excel_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../widgets/error_label.dart';
import '../widgets/app_header.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/order_bloc.dart';
import '../model/order.dart';
import 'global/next_page_route.dart';
import 'order_info_screen.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({
    Key? key,
    this.updateDate,
  }) : super(key: key);
  final Function? updateDate;

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
            return LoadingCircle();
          } else if (snapshot.data is OrderDataState) {
            OrderDataState state = snapshot.data as OrderDataState;
            return SizedBox.shrink();
            // TODO: remake it
            // return CalendarContent(
            //   orders: state.orderPack,
            //   updateDate: widget.updateDate,
            // );
          } else {
            return ErrorLabel(
              error: snapshot.error as Error,
              stackTrace: snapshot.stackTrace as StackTrace,
              onPressed: () {
                Bloc.bloc.orderBloc.loadAllOrders();
              },
            );
          }
        },
      ),
    );
  }
}

class CalendarContent extends StatefulWidget {
  CalendarContent({
    required this.orders,
    this.updateDate,
  });

  final List<Order> orders;
  final Function? updateDate;

  @override
  _CalendarContentState createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  final DateTime _currentDate = DateTime.now();
  final ValueNotifier<bool> _calendarNotifier = ValueNotifier(false);
  final ValueNotifier<DateTime?> _currentDate2Notifier = ValueNotifier(null);
  final ValueNotifier<String> _currentMonthNotifier =
      ValueNotifier(DateFormat.yMMM().format(DateTime.now()));
  final ValueNotifier<DateTime> _targetDateTimeNotifier =
      ValueNotifier(DateTime.now());

  @override
  void dispose() {
    if (widget.updateDate == null) Bloc.bloc.orderBloc.dispose();
    super.dispose();
  }

  void _updateCalendar() => _calendarNotifier.value = !_calendarNotifier.value;

  void _updateCurrentDate2(DateTime dateTime) {
    _currentDate2Notifier.value = dateTime;
    _updateCalendar();
    if (widget.updateDate != null) widget.updateDate!(dateTime);
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
  void didUpdateWidget(covariant CalendarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    for (int i = widget.orders.length - 1; i >= 0; i--) {
      if (widget.orders[i].done!) widget.orders.removeAt(i);
    }
    EventList<Event> _markedDateMap = EventList<Event>(
      events: Map<DateTime, List<Event>>.fromIterables(
        widget.orders.map((e) => DateFormat("dd.MM.yyyy").parse(e.date!)),
        widget.orders.map(
          (e) => [
            Event(
              id: e.id,
              date: DateFormat("dd.MM.yyyy").parse(e.date!),
              title:
                  '${(e.client!.name != '') ? (e.client!.name! + ' ') : ''}' +
                      '${e.client!.surname ?? ''}'
                          .replaceAll(RegExp(r"\s+"), ""),
            ),
          ],
        ),
      ),
    );
    ValueNotifier<List<Order>> _selectedOrders = ValueNotifier([]);
    return Scaffold(
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
                    builder: (BuildContext context, bool b, Widget? child) {
                      return CalendarCarousel<Event>(
                        customGridViewPhysics: NeverScrollableScrollPhysics(),
                        locale: "RU",
                        firstDayOfWeek: 1,
                        height: MediaQuery.of(context).size.height,
                        weekDayMargin: const EdgeInsets.only(bottom: 20),
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
                        isScrollable: false,
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
                            .bodyText1!
                            .copyWith(color: Theme.of(context).focusColor),
                        todayTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).cardColor),
                        markedDateCustomTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).highlightColor),
                        selectedDayTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).focusColor),
                        inactiveDaysTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).disabledColor),
                        weekendTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).cardColor),
                        prevDaysTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).disabledColor),
                        nextDaysTextStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).disabledColor),
                        onDayPressed: (date, events) {
                          _updateCurrentDate2(date);
                          _selectedOrders.value.clear();
                          events.forEach((ev) => _selectedOrders.value.addAll(
                              widget
                                  .orders
                                  .where((item) =>
                                      DateFormat("dd.MM.yyyy")
                                          .parse(item.date!) ==
                                      ev.date)
                                  .toList()));
                        },
                        onCalendarChanged: (DateTime date) {
                          _updateTargetDateTime(date);
                          _updateCurrentMonth(DateFormat.yMMM()
                              .format(_targetDateTimeNotifier.value));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox.expand(
            child: OrderBottomSheet(
              calendarNotifier: _calendarNotifier,
              selectedOrders: _selectedOrders,
              orders: widget.orders,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderBottomSheet extends StatelessWidget {
  const OrderBottomSheet({
    Key? key,
    required this.calendarNotifier,
    required this.selectedOrders,
    required this.orders,
  });

  final ValueNotifier<bool> calendarNotifier;
  final ValueNotifier<List<Order>> selectedOrders;
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
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
            valueListenable: calendarNotifier,
            builder: (BuildContext context, dynamic _, Widget? child) {
              return ListView.builder(
                controller: scrollController,
                itemCount: selectedOrders.value.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  String? appDocPath;
                  Future<void> getApplicationDirectoryPath() async {
                    Directory? appDir =
                        await ExcelHelper.getPhotosDirectory(context);
                    appDocPath = appDir?.path;
                  }

                  Future<Iterable<int>?> _getImage() async {
                    Iterable<int>? bytes;
                    if (appDocPath == null) await getApplicationDirectoryPath();
                    if (orders[index - 1].client!.avatar != null) {
                      var hasLocalImage =
                          File(orders[index - 1].client!.avatar!).existsSync();
                      if (hasLocalImage) {
                        bytes = File(orders[index - 1].client!.avatar!)
                            .readAsBytesSync();
                      }
                    }
                    return bytes;
                  }

                  if (index == 0) {
                    return Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Заказы',
                              style: Theme.of(context).textTheme.headline2,
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
                  } else {
                    Iterable<int>? bytes;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              NextPageRoute(
                                nextPage: OrderInfoScreen(
                                  title: 'Заказ',
                                  order: selectedOrders.value[index - 1],
                                  readMode: true,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            width: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24.0,
                                    backgroundColor:
                                        Theme.of(context).focusColor,
                                    child: FutureBuilder<Iterable<int>?>(
                                      future: _getImage(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Iterable<int>?>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          bytes = snapshot.data;
                                          if (bytes != null) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: MemoryImage(
                                                      bytes as Uint8List),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Icon(
                                              Icons.person,
                                              color:
                                                  Theme.of(context).cardColor,
                                            );
                                          }
                                        } else {
                                          return Icon(
                                            Icons.person,
                                            color: Theme.of(context).cardColor,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 14.0),
                                  Container(
                                    width: size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${(selectedOrders.value[index - 1].client!.name != '') ? (selectedOrders.value[index - 1].client!.name! + ' ') : ''}' +
                                              '${selectedOrders.value[index - 1].client!.surname ?? ''}'
                                                  .replaceAll(
                                                      RegExp(r"\s+"), ""),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          selectedOrders
                                              .value[index - 1].client!.city!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: size.width * 0.2,
                                    child: Text(
                                      (selectedOrders.value[index - 1].price !=
                                                  null &&
                                              selectedOrders.value[index - 1]
                                                      .expenses !=
                                                  null)
                                          ? (selectedOrders
                                                      .value[index - 1].price! -
                                                  selectedOrders
                                                      .value[index - 1]
                                                      .expenses!)
                                              .toString()
                                          : (selectedOrders
                                                      .value[index - 1].price !=
                                                  null)
                                              ? selectedOrders
                                                  .value[index - 1].price
                                                  .toString()
                                              : '0.0',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
