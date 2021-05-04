import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/app_header.dart';
import 'widgets/rect_button.dart';
import 'widgets/search_bar.dart';
import 'widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/order_bloc.dart';
import 'global/next_page_route.dart';
import 'order_info_screen.dart';
import '../model/order.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Работа',
        action: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).focusColor,
              size: 32.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: OrderInfoScreen(
                    title: 'Новый Заказ',
                    order: Order(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {

  @override
  void dispose() {
    Bloc.bloc.orderBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          SearchBar(),
          Expanded(
            child: StreamBuilder(
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
                    return _buildContent(state.orders);
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
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingCircle(),
    );
  }

  Widget _buildContent(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, i) {
        return _OrderCard(
          order: orders[i],
        );
      },
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

class _OrderCard extends StatefulWidget {
  const _OrderCard({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  __OrderCardState createState() => __OrderCardState();
}

class __OrderCardState extends State<_OrderCard> {
  String appDocPath;
  Iterable<int> bytes;

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  void init() {
    if (widget.order.client.avatar != null) {
      if (appDocPath == null) getApplicationDirectoryPath();
      if (widget.order.client.avatar != null) {
        var hasLocalImage = File(widget.order.client.avatar).existsSync();
        if (hasLocalImage) {
          bytes = File(widget.order.client.avatar).readAsBytesSync();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    String profit = (widget.order.price - widget.order.expenses)
        .toString()
        .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    if (widget.order.price > widget.order.expenses) profit = '+' + profit;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(
              context,
              NextPageRoute(
                nextPage: OrderInfoScreen(
                  title: 'Заказ',
                  order: widget.order,
                ),
              ),
            );
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            width: double.infinity,
            child: Row(
              children: [
                (widget.order.client.avatar != null)
                    ? ConstrainedBox(
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
                      )
                    : CircleAvatar(
                        radius: 24.0,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).cardColor,
                        ),
                        backgroundColor: Theme.of(context).focusColor,
                      ),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(widget.order.client.name != '') ? (widget.order.client.name + ' ') : ''}' +
                          '${widget.order.client.surname ?? ''}'
                              .replaceAll(RegExp(r"\s+"), ""),
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.order.date,
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  profit,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
