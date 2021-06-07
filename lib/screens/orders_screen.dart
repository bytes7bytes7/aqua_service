import 'dart:io';
import 'package:aqua_service/screens/widgets/error_label.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/app_header.dart';
import 'widgets/empty_label.dart';
import 'widgets/rect_button.dart';
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
      child: StreamBuilder(
        stream: Bloc.bloc.orderBloc.order,
        initialData: OrderInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is OrderInitState) {
            Bloc.bloc.orderBloc.loadAllOrders();
            return SizedBox.shrink();
          } else if (snapshot.data is OrderLoadingState) {
            return LoadingCircle();
          } else if (snapshot.data is OrderDataState) {
            OrderDataState state = snapshot.data;
            if (state.orders.length > 0) {
              return _OrderList(orders: state.orders);
            } else {
              return EmptyLabel();
            }
          } else {
            return ErrorLabel(
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

class _OrderList extends StatelessWidget {
  const _OrderList({Key key, this.orders}) : super(key: key);

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    List<Order> lstDone = [];
    List<Order> lstNotDone = [];
    orders.forEach((element) {
      if (element.done)
        lstDone.add(element);
      else
        lstNotDone.add(element);
    });
    return Column(
      children: [
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: orders.length + 2,
            itemBuilder: (context, i) {
              if (i == 0) {
                if (lstNotDone.length > 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Text(
                            'Не выполнено',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              } else if (i < lstNotDone.length + 1) {
                return _OrderCard(
                  order: lstNotDone[i - 1],
                );
              } else if (i == lstNotDone.length + 1) {
                if (lstDone.length > 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Text(
                            'Выполнено',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              } else {
                int index = i - lstNotDone.length - 2;
                return _OrderCard(
                  order: lstDone[index],
                );
              }
            },
          ),
        ),
      ],
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
    double value = (widget.order.price - widget.order.expenses);
    for (int i = 0; i < widget.order.fabrics.length; i++) {
      value += widget.order.fabrics[i].retailPrice -
          widget.order.fabrics[i].purchasePrice;
    }
    String profit = value.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
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
