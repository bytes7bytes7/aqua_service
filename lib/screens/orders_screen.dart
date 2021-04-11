import 'package:flutter/material.dart';

import '../screens/widgets/app_header.dart';
import '../screens/order_info_screen.dart';
import '../model/order.dart';
import '../bloc/order_bloc.dart';
import '../repository/order_repository.dart';
import './widgets/rect_button.dart';
import './widgets/search_bar.dart';
import './widgets/loading_circle.dart';
import 'global/next_page_route.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen(this._repo);

  final OrderRepository _repo;

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
            icon: Icon(Icons.add,
                color: Theme.of(context).focusColor, size: 32.0),
            onPressed: () {
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: OrderInfoScreen(title: 'Новый Заказ'),
                ),
              );
            },
          ),
        ],
      ),
      body: _Body(widget._repo),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(this._repo);

  final OrderRepository _repo;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  OrderBloc _orderBloc;

  @override
  void initState() {
    _orderBloc = OrderBloc(widget._repo);
    super.initState();
  }

  @override
  void dispose() {
    _orderBloc.dispose();
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
          //SortBar(),
          Expanded(
            child: StreamBuilder(
              stream: _orderBloc.order,
              initialData: OrderInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is OrderInitState) {
                  _orderBloc.getAllOrders();
                  return SizedBox.shrink();
                } else if (snapshot.data is OrderLoadingState) {
                  return _buildLoading();
                } else if (snapshot.data is OrderDataState) {
                  OrderDataState state = snapshot.data;
                  return _buildContent(state.orders);
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
              _orderBloc.getAllOrders();
            },
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    Key key,
    @required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
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
                  order: order,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(order.client.name != '') ? (order.client.name + ' ') : ''}' +
                          '${order.client.surname ?? ''}'
                              .replaceAll(RegExp(r"\s+"), ""),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      order.date,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    order.done ? Icons.done_all : Icons.timelapse_outlined,
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