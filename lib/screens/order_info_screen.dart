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

class OrderInfoScreen extends StatefulWidget {
  const OrderInfoScreen({
    Key key,
    @required this.title,
    @required this.order,
    this.readMode = false,
  }) : super(key: key);

  final String title;
  final Order order;
  final bool readMode;

  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  TextEditingController priceController;
  TextEditingController expensesController;
  TextEditingController commentController;
  Map<String, dynamic> changes = {};
  String _title;
  bool validateClient = false,
      validateDate = false,
      validatePrice = false,
      validateExpenses = false,
      validateFormat = false;

  @override
  void initState() {
    _title = widget.title;
    priceController = TextEditingController();
    expensesController = TextEditingController();
    commentController = TextEditingController();

    widget.order.client = widget.order.client ?? Client();
    // widget.order.price = widget.order.price;
    // widget.order.expenses = widget.order.expenses;
    widget.order.fabrics = widget.order.fabrics ?? [];
    // widget.order.date = widget.order.date;
    widget.order.done = widget.order.done ?? false;
    widget.order.comment = widget.order.comment ?? '';

    changes['client'] = Client.from(widget.order.client);
    changes['fabrics'] =
        widget.order.fabrics.map<Fabric>((e) => Fabric.from(e)).toList();
    if (widget.order.date == null || widget.order.date == '') {
      DateTime now = DateTime.now();
      changes['date'] = DateFormat('dd.MM.yyyy').format(now);
    } else {
      changes['date'] = widget.order.date;
    }
    changes['done'] = widget.order.done;

    priceController.text = widget.order.price?.toString();
    expensesController.text = widget.order.expenses?.toString();
    commentController.text = widget.order.comment;
    super.initState();
  }

  @override
  void dispose() {
    priceController.dispose();
    expensesController.dispose();
    commentController.dispose();
    super.dispose();
  }

  save() async {
    FocusScope.of(context).requestFocus(FocusNode());
    validateFormat = true;
    validateClient = changes['client'].id != null;
    validateDate = changes['date'] != null;
    validatePrice = priceController.text.length > 0;
    validateExpenses = expensesController.text.length > 0;
    validateFormat = priceValidation(priceController.text) &&
        priceValidation(expensesController.text);
    if (validatePrice &&
        validateExpenses &&
        validateFormat &&
        validateClient &&
        validateDate) {
      widget.order
        ..client = changes['client']
        ..price = double.parse(priceController.text)
        ..fabrics =
            changes['fabrics'].map<Fabric>((e) => Fabric.from(e)).toList()
        ..expenses = double.parse(expensesController.text)
        ..date = changes['date']
        ..done = changes['done']
        ..comment = commentController.text;
      if (widget.order.id == null) {
        await Bloc.bloc.orderBloc.addOrder(widget.order);
        print(widget.order.id);
        setState(() {
          _title = 'Заказ';
        });
      } else {
        Bloc.bloc.orderBloc.updateOrder(widget.order);
      }
      priceController.text = widget.order.price.toString();
      expensesController.text = widget.order.expenses.toString();
      Bloc.bloc.orderBloc.loadAllOrders();
    }
    if (validatePrice &&
        validateExpenses &&
        validateFormat &&
        validateClient &&
        validateDate)
      showInfoSnackBar(
          context: context, info: 'Сохранено!', icon: Icons.done_all_outlined);
    else if (!validateFormat)
      showInfoSnackBar(
          context: context,
          info: 'Неверный формат числа',
          icon: Icons.warning_amber_outlined);
    else if (!validateClient)
      showInfoSnackBar(
          context: context,
          info: 'Выберите клиента',
          icon: Icons.warning_amber_outlined);
    else
      showInfoSnackBar(
          context: context,
          info: 'Заполните поля со звездочкой',
          icon: Icons.warning_amber_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: _title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () async {
            if (!widget.readMode &&
                    !ListEquality()
                        .equals([changes['client']], [widget.order.client]) ||
                priceController.text != widget.order.price.toString() &&
                    !(!(priceController.text != '') &&
                        !(widget.order.price != null)) ||
                expensesController.text != widget.order.expenses.toString() &&
                    !(!(expensesController.text != '') &&
                        !(widget.order.expenses != null)) ||
                changes['date'] != widget.order.date ||
                !ListEquality()
                    .equals(changes['fabrics'], widget.order.fabrics) ||
                commentController.text != widget.order.comment) {
              showNoYesDialog(
                context: context,
                title: 'Изменения будут утеряны',
                subtitle: 'Покинуть карту заказа?',
                noAnswer: () {
                  Navigator.pop(context);
                },
                yesAnswer: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        action: [
          if (widget.order.id != null && !widget.readMode)
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).focusColor,
                ),
                onPressed: () {
                  showNoYesDialog(
                    context: context,
                    title: 'Удаление',
                    subtitle: 'Удалить заказ?',
                    noAnswer: () {
                      Navigator.of(context).pop();
                    },
                    yesAnswer: () {
                      Bloc.bloc.orderBloc.deleteOrder(widget.order.id);
                      Bloc.bloc.orderBloc.loadAllOrders();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                }),
          if (!widget.readMode)
            IconButton(
              icon: Icon(
                Icons.done,
                color: Theme.of(context).focusColor,
              ),
              onPressed: () {
                save();
              },
            ),
        ],
      ),
      body: _Body(
        save: save,
        readMode: widget.readMode,
        changes: changes,
        priceController: priceController,
        expensesController: expensesController,
        commentController: commentController,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.save,
    @required this.readMode,
    @required this.changes,
    @required this.priceController,
    @required this.expensesController,
    @required this.commentController,
  }) : super(key: key);

  final Function save;
  final bool readMode;
  final Map<String, dynamic> changes;
  final TextEditingController priceController;
  final TextEditingController expensesController;
  final TextEditingController commentController;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final DateFormat dateTimeFormat = DateFormat("dd.MM.yyyy");
  ValueNotifier<bool> _fabricsNotifier = ValueNotifier(true);
  ValueNotifier<DateTime> _dateTimeNotifier;
  ValueNotifier<bool> _doneNotifier;
  String appDocPath;
  Iterable<int> bytes;

  _addFabric(Fabric fabric) {
    if (fabric.id != null) {
      for (int i = 0; i < widget.changes['fabrics'].length; i++) {
        if (widget.changes['fabrics'][i].id == fabric.id) {
          showInfoSnackBar(
              context: context,
              info: 'Материал уже выбран',
              icon: Icons.warning_amber_outlined);
          return;
        }
      }
      widget.changes['fabrics'].add(Fabric.from(fabric));
      _fabricsNotifier.value = !_fabricsNotifier.value;
    }
  }

  _removeFabric(int id) {
    for (int i = 0; i < widget.changes['fabrics'].length; i++)
      if (widget.changes['fabrics'][i].id == id) {
        widget.changes['fabrics'].removeAt(i);
        break;
      }
    _fabricsNotifier.value = !_fabricsNotifier.value;
  }

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  _updateDateTime(DateTime dateTime) {
    _dateTimeNotifier.value = dateTime;
    widget.changes['date'] = dateTimeFormat.format(_dateTimeNotifier.value);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _dateTimeNotifier =
        ValueNotifier(dateTimeFormat.parse(widget.changes['date']));
    _doneNotifier = ValueNotifier(widget.changes['done']);
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.changes['client'] != null &&
        widget.changes['client'].avatar != null) {
      var hasLocalImage = File(widget.changes['client'].avatar).existsSync();
      if (hasLocalImage) {
        bytes = File(widget.changes['client'].avatar).readAsBytesSync();
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
                  readMode: widget.readMode,
                  changes: widget.changes,
                ),
                TextField(
                  controller: widget.priceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: !widget.readMode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Стоимость *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.expensesController,
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: !widget.readMode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Затраты *',
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
                        (widget.priceController.text != '' &&
                                widget.expensesController.text != '')
                            ? (double.parse(widget.priceController.text) -
                                    double.parse(
                                        widget.expensesController.text))
                                .toString()
                            : '0.0',
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
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: (widget.readMode)
                            ? () {}
                            : () {
                                Navigator.push(
                                  context,
                                  NextPageRoute(
                                    nextPage: CalendarScreen(
                                      updateDate: _updateDateTime,
                                    ),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Материалы :',
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: (widget.readMode)
                            ? () {}
                            : () {
                                Navigator.push(
                                  context,
                                  NextPageRoute(
                                    nextPage: FabricsScreen(
                                      addFabric: _addFabric,
                                    ),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
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
                          (BuildContext context, bool updated, Widget child) {
                        if (widget.changes['fabrics'].length == 0) {
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
                              widget.changes['fabrics'].length,
                              (index) {
                                return _FabricCard(
                                  readMode: widget.readMode,
                                  fabric: widget.changes['fabrics'][index],
                                  removeFabric: _removeFabric,
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
                            controller: widget.commentController,
                            enabled: !widget.readMode,
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
                      text: (widget.changes['done']) ? 'Заново' : 'Завершить',
                      onPressed: (widget.readMode)
                          ? () {}
                          : () {
                              _doneNotifier.value = !_doneNotifier.value;
                              widget.changes['done'] = _doneNotifier.value;
                              widget.save();
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
    @required this.readMode,
    @required this.changes,
  }) : super(key: key);

  final bool readMode;
  final Map<String, dynamic> changes;

  @override
  __ClientCardState createState() => __ClientCardState();
}

class __ClientCardState extends State<_ClientCard> {
  final ValueNotifier<Client> _clientNotifier = ValueNotifier(Client());
  String appDocPath;
  Iterable<int> bytes;

  _updateClient(Client client) {
    if (client.id != null) {
      _clientNotifier.value = Client.from(client);
      widget.changes['client'] = Client.from(client);
      if (widget.changes['client'].avatar != null)
        bytes = File(widget.changes['client'].avatar).readAsBytesSync();
    }
  }

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  void init() {
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.changes['client'].avatar != null) {
      var hasLocalImage = File(widget.changes['client'].avatar).existsSync();
      if (hasLocalImage)
        bytes = File(widget.changes['client'].avatar).readAsBytesSync();
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
            if (widget.changes['client'].id != null)
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: ClientInfoScreen(
                    title: 'Клиент',
                    client: widget.changes['client'],
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
                    if (widget.changes['client'].avatar != null) {
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
                    if (widget.changes['client'].id != null) {
                      return Text(
                        '${(widget.changes['client'].name != '') ? (widget.changes['client'].name + ' ') : ''}' +
                            '${widget.changes['client'].surname ?? ''}'
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
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).focusColor,
                  ),
                  onPressed: (widget.readMode)
                      ? () {}
                      : () async {
                          Navigator.push(
                            context,
                            NextPageRoute(
                                nextPage: ClientsScreen(
                              updateClient: _updateClient,
                            )),
                          );
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
    @required this.readMode,
    @required this.fabric,
    @required this.removeFabric,
  }) : super(key: key);

  final bool readMode;
  final Fabric fabric;
  final Function removeFabric;

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
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).focusColor,
            ),
            onPressed: (readMode)
                ? () {}
                : () {
                    removeFabric(fabric.id);
                  },
          ),
        ],
      ),
    );
  }
}
