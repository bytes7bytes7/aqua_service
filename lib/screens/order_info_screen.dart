import 'package:aqua_service/screens/widgets/rect_button.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {},
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Дата: ${order.date}',
                        style: Theme.of(context).textTheme.headline3,
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
                SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 0.4*MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(width: 2.0,color: Theme.of(context).focusColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: (order.comment!= '') ? Text(
                        order.comment,
                        style: Theme.of(context).textTheme.bodyText1,
                      ): Text(
                        'Ваш комментарий...',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RectButton(
                  text: 'Выполнено',
                  onPressed: () {},
                ),
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
                Text(
                  '${(order.client.name != '') ? (order.client.name + ' ') : ''}' +
                      '${order.client.surname ?? ''}'
                          .replaceAll(RegExp(r"\s+"), ""),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).focusColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
