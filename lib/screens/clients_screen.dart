import 'package:aqua_service/repository/repository.dart';
import 'package:flutter/material.dart';

import '../screens/widgets/app_header.dart';
import '../bloc/client_bloc.dart';
import '../repository/client_repository.dart';
import './widgets/rect_button.dart';
import './widgets/search_bar.dart';
import './widgets/loading_circle.dart';
import '../model/client.dart';
import '../screens/client_info_screen.dart';
import 'global/next_page_route.dart';
import '../screens/global/next_page_route.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({
    Key key,
    this.forChoice = false,
  }) : super(key: key);

  final bool forChoice;

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Клиенты',
        action: [
          IconButton(
            icon: Icon(Icons.add,
                color: Theme
                    .of(context)
                    .focusColor, size: 32.0),
            onPressed: () {
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: ClientInfoScreen(title: 'Новый Клиент'),
                ),
              );
            },
          ),
        ],
      ),
      body: _Body(forChoice: widget.forChoice),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({
    Key key,
    @required this.forChoice,
  }) : super(key: key);

  final bool forChoice;
  final ClientRepository _repo = Repository.clientRepository;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  ClientBloc _clientBloc;

  @override
  void initState() {
    _clientBloc = ClientBloc(widget._repo);
    super.initState();
  }

  @override
  void dispose() {
    _clientBloc.dispose();
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
              stream: _clientBloc.client,
              initialData: ClientInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is ClientInitState) {
                  _clientBloc.loadAllClients();
                  return SizedBox.shrink();
                } else if (snapshot.data is ClientLoadingState) {
                  return _buildLoading();
                } else if (snapshot.data is ClientDataState) {
                  ClientDataState state = snapshot.data;
                  return _buildContent(state.clients);
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

  Widget _buildContent(List<Client> clients) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, i) {
        return _ClientCard(
          client: clients[i],
          forChoice: widget.forChoice,
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
            style: Theme
                .of(context)
                .textTheme
                .headline1,
          ),
          SizedBox(height: 20),
          RectButton(
              text: 'Обновить',
              onPressed: () {
                _clientBloc.loadAllClients();
              }),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    Key key,
    @required this.client,
    @required this.forChoice,
  }) : super(key: key);

  final Client client;
  final bool forChoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (!forChoice) ? () {
            Navigator.push(
              context,
              NextPageRoute(
                nextPage: ClientInfoScreen(
                  title: 'Клиент',
                  client: client,
                ),
              ),
            );
          } : () {},
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            width: double.infinity,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.0,
                  child: Icon(
                    Icons.person,
                    color: Theme
                        .of(context)
                        .cardColor,
                  ),
                  backgroundColor: Theme
                      .of(context)
                      .focusColor,
                ),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(client.name != '') ? (client.name + ' ') : ''}' +
                          '${client.surname ?? ''}'
                              .replaceAll(RegExp(r"\s+"), ""),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      client.city,
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
