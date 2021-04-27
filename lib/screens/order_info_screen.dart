/*import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../bloc/order_bloc.dart';
import 'clients_screen.dart';
import 'fabrics_screen.dart';
import '../screens/widgets/rect_button.dart';
import '../screens/widgets/app_header.dart';
import '../model/order.dart';
import 'client_info_screen.dart';
import 'global/next_page_route.dart';
import 'widgets/show_no_yes_dialog.dart';

class OrderInfoScreen extends StatefulWidget {
  const OrderInfoScreen({
    Key key,
    @required this.title,
    @required this.order,
    @required this.bloc,
  }) : super(key: key);

  final String title;
  final Order order;
  final OrderBloc bloc;

  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  TextEditingController priceController;
  TextEditingController expensesController;
  TextEditingController commentController;
  List<int> clientId;
  List<int> fabricIds;
  List<String> date;
  List<bool> done;
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
    widget.order.price = widget.order.price ?? 0.0;
    widget.order.fabricIds = widget.order.fabricIds ?? [];
    widget.order.expenses = widget.order.expenses ?? 0.0;
    widget.order.date = widget.order.date ?? '';
    widget.order.done = widget.order.done ?? false;
    widget.order.comment = widget.order.comment ?? '';

    clientId = [widget.order.clientId];
    fabricIds = List<int>.from(widget.order.fabricIds) ?? [];
    date = [widget.order.date];
    done = [widget.order.done];

    priceController.text = widget.order.price.toString();
    expensesController.text = widget.order.expenses.toString();
    commentController.text = widget.order.comment;
  }

  @override
  Widget build(BuildContext context) {
    init();
    bool validateClientId = false,
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
                clientId[0] != widget.order.clientId ||
                !ListEquality().equals(fabricIds, widget.order.fabricIds) ||
                date[0] != widget.order.date) {
              showNoYesDialog(
                context: context,
                title: 'Изменения будут утеряны',
                subtitle: 'Покинуть карту заказа?',
                noAnswer: () {
                  Navigator.pop(context);
                },
                yesAnswer:() {
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
          if (widget.client.id != null)
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).focusColor,
                ),
                onPressed: () {
                  showNoYesDialog(
                    context: context,
                    title:
                  );
                }),
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              validateName = nameController.text.length > 0;
              validateCity = cityController.text.length > 0;
              if (validateName && validateCity) {
                widget.client
                  ..avatar = avatarPath[0]
                  ..name = nameController.text
                  ..surname = surnameController.text
                  ..middleName = middleNameController.text
                  ..city = cityController.text
                  ..address = addressController.text
                  ..phone = phoneController.text
                  ..volume = volumeController.text
                  ..images = imagesPath;
                if (widget.client.id == null) {
                  widget.bloc.addClient(widget.client);
                  setState(() {
                    _title = 'Клиент';
                  });
                } else {
                  widget.bloc.updateClient(widget.client);
                }
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  duration: const Duration(seconds: 1),
                  content: Row(
                    children: [
                      Text(
                        (validateName && validateCity)
                            ? 'Сохранено!'
                            : 'Заполните поля со звездочкой',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      Icon(
                        (validateName && validateCity)
                            ? Icons.done_all_outlined
                            : Icons.warning_amber_outlined,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _Body(order: widget.order),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String fabrics = '';
    // if (order != null && order.fabricIds != null && order.fabricIds.length > 0) {
    //   fabrics = order.fabrics[0].title;
    //   for (int i = 1; i < order.fabrics.length; i++)
    //     fabrics += ', ' + order.fabrics[i].title;
    // }
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
                _ClientCard(order: order),
                TextField(
                  controller: TextEditingController(
                      text: (order != null && order.price != null)
                          ? order.price.toString()
                          : ''),
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
                  controller: TextEditingController(
                      text: (order != null && order.expenses != null)
                          ? order.expenses.toString()
                          : ''),
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
                        'Материалы : ' + fabrics,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.content_paste_outlined,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            NextPageRoute(
                                nextPage: FabricsScreen(forChoice: true)),
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
                        'Дата : ${(order != null) ? order.date : ''}',
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
                        'Прибыль : ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        ((order != null &&
                                order.price != null &&
                                order.expenses != null)
                            ? (order.price - order.expenses).toString()
                            : ''),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
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
                            controller: controller,
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
                  text: (order != null && order.done) ? 'Заново' : 'Завершить',
                  onPressed: () {},
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

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (order != null)
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: ClientInfoScreen(
                    title: 'Клиент',
                    client: order.client,
                  ),
                ),
              );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
            width: double.infinity,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.0,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).cardColor,
                  ),
                  backgroundColor: Theme.of(context).focusColor,
                ),
                SizedBox(width: 14.0),
                (order != null)
                    ? Text(
                        '${(order.client.name != '') ? (order.client.name + ' ') : ''}' +
                            '${order.client.surname ?? ''}'
                                .replaceAll(RegExp(r"\s+"), ""),
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        'Не выбран',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).disabledColor),
                      ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).focusColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      NextPageRoute(nextPage: ClientsScreen(forChoice: true)),
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
*/