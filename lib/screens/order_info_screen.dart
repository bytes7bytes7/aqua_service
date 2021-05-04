import 'dart:io';

import 'package:aqua_service/bloc/bloc.dart';
import 'package:aqua_service/screens/global/show_info_snack_bar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../model/client.dart';
import '../model/fabric.dart';
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
  }) : super(key: key);

  final String title;
  final Order order;

  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  TextEditingController priceController;
  TextEditingController expensesController;
  TextEditingController commentController;
  Map<String, dynamic> changes = {};
  String _title;

  @override
  void initState() {
    _title = widget.title;
    priceController = TextEditingController();
    expensesController = TextEditingController();
    commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    priceController.dispose();
    expensesController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void init() {
    widget.order.client = widget.order.client ?? Client();
    widget.order.price = widget.order.price ?? 0.0;
    widget.order.fabrics = widget.order.fabrics ?? [];
    widget.order.expenses = widget.order.expenses ?? 0.0;
    widget.order.date = widget.order.date ?? '';
    widget.order.done = widget.order.done ?? false;
    widget.order.comment = widget.order.comment ?? '';

    changes['client'] = Client.from(widget.order.client);
    changes['fabrics'] =
        widget.order.fabrics.map((e) => Fabric.from(e)).toList();
    changes['date'] = widget.order.date;
    changes['done'] = widget.order.done;

    priceController.text = widget.order.price.toString();
    expensesController.text = widget.order.expenses.toString();
    commentController.text = widget.order.comment;
  }

  @override
  Widget build(BuildContext context) {
    init();
    bool validateClient = false,
        validateDate = false,
        validatePrice = false,
        validateExpenses = false,
        validateFormat = false;
    return Scaffold(
      appBar: AppHeader(
        title: _title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            if (priceController.text != widget.order.price.toString() ||
                expensesController.text != widget.order.expenses.toString() ||
                commentController.text != widget.order.comment ||
                !ListEquality()
                    .equals([changes['client']], [widget.order.client]) ||
                !ListEquality()
                    .equals(changes['fabrics'], widget.order.fabrics) ||
                changes['date'] != widget.order.date) {
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
          if (widget.order.id != null)
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
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              validateFormat = true;
              validateClient = changes['client'] != null;
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
                  ..fabrics = changes['fabrics']
                  ..expenses = double.parse(expensesController.text)
                  ..date = changes['date']
                  ..done = changes['done']
                  ..comment = commentController.text;
                (widget.order.id == null)
                    ? Bloc.bloc.orderBloc.addOrder(widget.order)
                    : Bloc.bloc.orderBloc.updateOrder(widget.order);
                Bloc.bloc.orderBloc.loadAllOrders();
                setState(() {
                  _title = 'Заказ';
                });
              }
              if (validatePrice &&
                  validateExpenses &&
                  validateFormat &&
                  validateClient &&
                  validateDate)
                showInfoSnackBar(
                    context: context,
                    info: 'Сохранено!',
                    icon: Icons.done_all_outlined);
              else if (!validateFormat)
                showInfoSnackBar(
                    context: context,
                    info: 'Неверный формат числа',
                    icon: Icons.warning_amber_outlined);
              else if (!validateClient || !validateDate)
                showInfoSnackBar(
                    context: context,
                    info: 'Выберите Клиента и Дату',
                    icon: Icons.warning_amber_outlined);
              else
                showInfoSnackBar(
                    context: context,
                    info: 'Заполните поля со звездочкой',
                    icon: Icons.warning_amber_outlined);
            },
          ),
        ],
      ),
      body: _Body(
        changes: changes,
        order: widget.order,
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
    @required this.changes,
    @required this.order,
    @required this.priceController,
    @required this.expensesController,
    @required this.commentController,
  }) : super(key: key);

  final Map<String, dynamic> changes;
  final Order order;
  final TextEditingController priceController;
  final TextEditingController expensesController;
  final TextEditingController commentController;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final ValueNotifier<List<Fabric>> _fabricsNotifier =
      ValueNotifier(List<Fabric>.from([]));
  String appDocPath;
  Iterable<int> bytes;

  _updateFabrics(Fabric fabric) {
    var tmp = Fabric.from(fabric);
    _fabricsNotifier.value.add(Fabric.from(tmp));
    //widget.order.fabrics.add(Fabric.from(tmp));
    widget.changes['fabrics'].add(tmp);
  }

  _removeFabric(int id) {
    for (int i = 0; i < widget.changes['fabrics'].length; i++) {
      if (widget.changes['fabrics'][i].id == id) {
        // widget.order.fabrics.removeAt(i);
        _fabricsNotifier.value.removeAt(i);
        widget.changes['fabrics'].removeAt(i);
        break;
      }
    }
  }

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  @override
  void initState() {
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
                  order: widget.order,
                  changes: widget.changes,
                ),
                TextField(
                  controller: widget.priceController,
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
                  controller: widget.expensesController,
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
                        ((widget.order != null &&
                                widget.order.price != null &&
                                widget.order.expenses != null)
                            ? (widget.order.price - widget.order.expenses)
                                .toString()
                            : ''),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Дата : ${(widget.order != null) ? widget.order.date : ""}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Материалы:',
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            NextPageRoute(
                              nextPage: FabricsScreen(
                                updateFabrics: _updateFabrics,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _fabricsNotifier,
                  builder: (BuildContext context, List<Fabric> fabrics,
                      Widget child) {
                    if (fabrics.length > 0) {
                      return Column(
                        children: List.generate(
                          fabrics.length,
                          (index) {
                            return _FabricCard(
                              fabric: fabrics[index],
                              removeFabric: _removeFabric,
                            );
                          },
                        ),
                      );
                    } else
                      return SizedBox.shrink();
                  },
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
                RectButton(
                  text: (widget.order != null && widget.order.done)
                      ? 'Заново'
                      : 'Завершить',
                  onPressed: () {
                    //TODO: add complete order function
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
    @required this.order,
    @required this.changes,
  }) : super(key: key);

  final Order order;
  final Map<String, dynamic> changes;

  @override
  __ClientCardState createState() => __ClientCardState();
}

class __ClientCardState extends State<_ClientCard> {
  final ValueNotifier<Client> _clientNotifier = ValueNotifier(Client());
  String appDocPath;
  Iterable<int> bytes;

  _updateClient(Client client) {
    _clientNotifier.value = (client.id != null) ? client : Client();
    // widget.order.client = Client.from(_clientNotifier.value);
    widget.changes['client'] = widget.order.client;
    bytes = File(widget.order.client.avatar).readAsBytesSync();
  }

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  void init() {
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.order.client.avatar != null) {
      var hasLocalImage = File(widget.order.client.avatar).existsSync();
      if (hasLocalImage)
        bytes = File(widget.order.client.avatar).readAsBytesSync();
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
            if (widget.order.client.id != null)
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: ClientInfoScreen(
                    title: 'Клиент',
                    client: widget.order.client,
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
                    if (widget.order.client.avatar != null) {
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
                    if (widget.order.client.id != null) {
                      return Text(
                        '${(widget.order.client.name != '') ? (widget.order.client.name + ' ') : ''}' +
                            '${widget.order.client.surname ?? ''}'
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
                  onPressed: () async {
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
    @required this.fabric,
    @required this.removeFabric,
  }) : super(key: key);

  final Fabric fabric;
  final Function removeFabric;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Text(
            '- ${fabric.title}',
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor,
            ),
            onPressed: removeFabric(fabric.id),
          ),
        ],
      ),
    );
  }
}
