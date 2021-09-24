import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../widgets/error_label.dart';
import '../widgets/app_header.dart';
import '../widgets/empty_label.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/order_bloc.dart';
import '../model/client.dart';
import '../model/order.dart';
import 'global/next_page_route.dart';
import 'order_info_screen.dart';

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
            Bloc.bloc.orderBloc.loadAllOrdersGrouped();
            return SizedBox.shrink();
          } else if (snapshot.data is OrderLoadingState) {
            return LoadingCircle();
          } else if (snapshot.data is OrderDataGroupedState) {
            OrderDataGroupedState state =
                snapshot.data as OrderDataGroupedState;
            if (state.orderPack.length > 0) {
              return _OrderList(orderPack: state.orderPack);
            } else {
              return EmptyLabel();
            }
          } else if (snapshot.data is OrderDataState) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).focusColor,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ошибка',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      'snapshot.data is OrderDataState',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            );
          } else {
            print(snapshot.hasData);
            print(snapshot.hasError);
            return ErrorLabel(
              error: snapshot.error as Error,
              stackTrace: snapshot.stackTrace as StackTrace,
              onPressed: () {
                Bloc.bloc.orderBloc.loadAllOrdersGrouped();
              },
            );
          }
        },
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({Key? key, required this.orderPack}) : super(key: key);

  final Map<Client, List<Order>> orderPack;

  @override
  Widget build(BuildContext context) {
    List<Client> keys = orderPack.keys.toList();
    keys.sort((a, b) => a.name!.compareTo(b.name!));
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, i) {
        return _OrderPackCard(
          orderPack: {keys[i]: orderPack[keys[i]]!},
        );
      },
    );
  }
}

class _OrderPackCard extends StatefulWidget {
  const _OrderPackCard({
    Key? key,
    required this.orderPack,
  }) : super(key: key);

  final Map<Client, List<Order>> orderPack;

  @override
  __OrderCardState createState() => __OrderCardState();
}

class __OrderCardState extends State<_OrderPackCard> {
  final GlobalKey<ExpansionTileCardState> tileKey = GlobalKey();

  Iterable<int>? bytes;
  late Client client;
  late List<Order> orders;

  void init() {
    widget.orderPack.forEach((key, value) {
      client = key;
      orders = value;
    });
    if (client.avatar != null) {
      var hasLocalImage = File(client.avatar!).existsSync();
      if (hasLocalImage) {
        bytes = File(client.avatar!).readAsBytesSync();
      }
    }
  }

  String getProfit(Order order) {
    double value = order.price!;
    if (order.expenses != null) {
      value -= order.expenses!;
    }
    for (int i = 0; i < order.fabrics!.length; i++) {
      value +=
          order.fabrics![i].retailPrice! - order.fabrics![i].purchasePrice!;
    }
    String profit = value.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    if (order.expenses == null) {
      profit = '+' + profit;
    } else if (order.price! > order.expenses!) {
      profit = '+' + profit;
    }
    return profit;
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 28.0),
      child: ExpansionTile(
        key: tileKey,
        tilePadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        iconColor: Theme.of(context).focusColor,
        collapsedIconColor: Theme.of(context).focusColor,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
        title: Row(
          children: [
            (client.avatar != null && bytes != null)
                ? Container(
                    height: 48.0,
                    width: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: MemoryImage(bytes as Uint8List),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : (client.avatar != null)
                    ? CircleAvatar(
                        radius: 24.0,
                        child: Icon(
                          Icons.error_outline_outlined,
                          color: Theme.of(context).errorColor,
                        ),
                        backgroundColor:
                            Theme.of(context).errorColor.withOpacity(0.5),
                      )
                    : CircleAvatar(
                        radius: 24.0,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).cardColor,
                        ),
                        backgroundColor: Theme.of(context).focusColor,
                      ),
            const SizedBox(width: 14.0),
            Text(
              '${(client.name != '') ? (client.name! + ' ') : ''}' +
                  '${client.surname ?? ''}'.replaceAll(RegExp(r"\s+"), ""),
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        children: List.generate(
          orders.length,
          (index) {
            return Column(
              children: [
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
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
                              order: orders[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Icon(
                                    (orders[index].done!)
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: Theme.of(context).focusColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    orders[index].date!,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                getProfit(orders[index]),
                                textAlign: TextAlign.end,
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
