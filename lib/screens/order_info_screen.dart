import 'package:aqua_service/screens/clients_screen.dart';
import 'package:aqua_service/screens/fabrics_screen.dart';
import 'package:flutter/material.dart';

import '../screens/widgets/rect_button.dart';
import '../screens/widgets/app_header.dart';
import '../model/order.dart';
import 'client_info_screen.dart';
import 'global/next_page_route.dart';

class OrderInfoScreen extends StatefulWidget {
  const OrderInfoScreen({
    Key key,
    @required this.title,
    this.order,
  }) : super(key: key);

  final String title;
  final Order order;

  @override
  _OrderInfoScreenState createState() => _OrderInfoScreenState();
}

class _OrderInfoScreenState extends State<OrderInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: widget.title,
        action: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () {

            },
          ),
        ],
      ),
      body: _Body(order: widget.order),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    String fabrics = '';
    if (order != null && order.fabrics != null && order.fabrics.length > 0) {
      fabrics = order.fabrics[0].title;
      for (int i = 1; i < order.fabrics.length; i++)
        fabrics += ', ' + order.fabrics[i].title;
    }
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
                            NextPageRoute(nextPage: FabricsScreen(forChoice: true)),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 0.4 * MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                          width: 2.0, color: Theme.of(context).focusColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: (order != null && order.comment != '')
                          ? Text(
                              order.comment,
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              'Ваш комментарий...',
                              style: Theme.of(context).textTheme.headline3,
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
