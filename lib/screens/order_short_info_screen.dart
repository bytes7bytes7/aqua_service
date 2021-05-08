import 'dart:io';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/bloc.dart';
import '../model/fabric.dart';
import 'calendar_screen.dart';
import 'global/show_info_snack_bar.dart';
import '../model/client.dart';
import '../model/order.dart';
import 'client_info_screen.dart';
import 'clients_screen.dart';
import 'fabrics_screen.dart';
import 'widgets/rect_button.dart';
import 'widgets/app_header.dart';
import 'widgets/show_no_yes_dialog.dart';
import 'global/validate_price.dart';
import 'global/next_page_route.dart';

class OrderShortInfoScreen extends StatefulWidget {
  const OrderShortInfoScreen({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  _OrderShortInfoScreenState createState() => _OrderShortInfoScreenState();
}

class _OrderShortInfoScreenState extends State<OrderShortInfoScreen> {
  @override
  void initState() {
    widget.order.client = widget.order.client ?? Client();
    widget.order.price = widget.order.price ?? 0.0;
    widget.order.fabrics = widget.order.fabrics ?? [];
    widget.order.expenses = widget.order.expenses ?? 0.0;
    // widget.order.date = widget.order.date;
    widget.order.done = widget.order.done ?? false;
    widget.order.comment = widget.order.comment ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(
        order: widget.order,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final DateFormat dateTimeFormat = DateFormat("dd.MM.yyyy");
  ValueNotifier<Fabric> _fabricsNotifier = ValueNotifier(Fabric());
  ValueNotifier<DateTime> _dateTimeNotifier;
  ValueNotifier<bool> _doneNotifier;
  String appDocPath;
  Iterable<int> bytes;

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  @override
  void initState() {
    _dateTimeNotifier = ValueNotifier(dateTimeFormat.parse(widget.order.date));
    _doneNotifier = ValueNotifier(widget.order.done);
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.order.client != null && widget.order.client.avatar != null) {
      var hasLocalImage = File(widget.order.client.avatar).existsSync();
      if (hasLocalImage) {
        bytes = File(widget.order.client.avatar).readAsBytesSync();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
            child: Column(
              children: [
                _ClientCard(
                  client: widget.order.client,
                ),
                TextField(
                  enabled: false,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Стоимость',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  enabled: false,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Затраты',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Прибыль : ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        (widget.order.price - widget.order.expenses).toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Дата : ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _dateTimeNotifier,
                        builder: (BuildContext context, DateTime dateTime,
                            Widget child) {
                          String date = '-- -- --';
                          if (dateTime != null) {
                            String day, month, year;
                            day = dateTime.day.toString();
                            month = dateTime.month.toString();
                            year = dateTime.year.toString();
                            while (day.length < 2) day = '0' + day;
                            while (month.length < 2) month = '0' + month;
                            while (year.length < 4) year = '0' + year;
                            date = '$day.$month.$year';
                          }

                          return Text(
                            date,
                            style: Theme.of(context).textTheme.bodyText1,
                          );
                        },
                      ),

                    ],
                  ),
                ),
                Text(
                  'Материалы :',
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  child: Container(
                    height: 200,
                    child: ValueListenableBuilder(
                      valueListenable: _fabricsNotifier,
                      builder:
                          (BuildContext context, Fabric fabric, Widget child) {
                        if (widget.order.fabrics.length == 0) {
                          return Center(
                            child: Text(
                              'Пусто',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          );
                        } else {
                          return ListView(
                            controller: ScrollController(),
                            children: List.generate(
                              widget.order.fabrics.length,
                              (index) {
                                return _FabricCard(
                                  fabric: widget.order.fabrics[index],
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 0.4 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        width: 2.0, color: Theme.of(context).focusColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "Ваш комментарий",
                              hintStyle: Theme.of(context).textTheme.headline3,
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context).textTheme.bodyText1,
                            scrollPadding: EdgeInsets.all(20.0),
                            keyboardType: TextInputType.multiline,
                            maxLines: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ValueListenableBuilder(
                  valueListenable: _doneNotifier,
                  builder: (BuildContext context, bool done, Widget child) {
                    return RectButton(
                      text: (widget.order.done) ? 'Заново' : 'Завершить',
                      onPressed: () {
                        _doneNotifier.value = !_doneNotifier.value;
                        widget.order.done = _doneNotifier.value;
                      },
                    );
                  },
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatefulWidget {
  const _ClientCard({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  __ClientCardState createState() => __ClientCardState();
}

class __ClientCardState extends State<_ClientCard> {
  final ValueNotifier<Client> _clientNotifier = ValueNotifier(Client());
  String appDocPath;
  Iterable<int> bytes;

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  void init() {
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.client.avatar != null) {
      var hasLocalImage = File(widget.client.avatar).existsSync();
      if (hasLocalImage)
        bytes = File(widget.client.avatar).readAsBytesSync();
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (widget.client.id != null)
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: ClientInfoScreen(
                    title: 'Клиент',
                    client: widget.client,
                    readMode: true,
                  ),
                ),
              );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            width: double.infinity,
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: _clientNotifier,
                  builder: (BuildContext context, Client client, Widget child) {
                    if (widget.client.avatar != null) {
                      return ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 50, height: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(bytes),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 24.0,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).cardColor,
                        ),
                        backgroundColor: Theme.of(context).focusColor,
                      );
                    }
                  },
                ),
                SizedBox(width: 14.0),
                ValueListenableBuilder(
                  valueListenable: _clientNotifier,
                  builder: (BuildContext context, Client client, Widget child) {
                    if (widget.client.id != null) {
                      return Text(
                        '${(widget.client.name != '') ? (widget.client.name + ' ') : ''}' +
                            '${widget.client.surname ?? ''}'
                                .replaceAll(RegExp(r"\s+"), ""),
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Text(
                        'Не выбран',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).disabledColor),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FabricCard extends StatelessWidget {
  const _FabricCard({
    Key key,
    @required this.fabric,
  }) : super(key: key);

  final Fabric fabric;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            fabric.title,
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Text(
            (fabric.retailPrice - fabric.purchasePrice).toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
