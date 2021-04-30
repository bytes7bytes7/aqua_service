import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../repository/repository.dart';
import '../screens/widgets/app_header.dart';
import '../bloc/client_bloc.dart';
import './widgets/rect_button.dart';
import './widgets/search_bar.dart';
import './widgets/loading_circle.dart';
import '../model/client.dart';
import '../screens/client_info_screen.dart';
import 'global/next_page_route.dart';
import '../screens/global/next_page_route.dart';

class ClientsScreen extends StatefulWidget {
  ClientsScreen({
    Key key,
    this.changes,
  }) : super(key: key);

  final Map<String, dynamic> changes;
  final _repo = Repository.clientRepository;

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
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
    return Scaffold(
      appBar: AppHeader(
        title: 'Клиенты',
        action: (widget.changes != null)
            ? []
            : [
                IconButton(
                  icon: Icon(Icons.add,
                      color: Theme.of(context).focusColor, size: 32.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      NextPageRoute(
                        nextPage: ClientInfoScreen(
                          title: 'Новый Клиент',
                          client: Client(),
                          bloc: _clientBloc,
                        ),
                      ),
                    );
                  },
                ),
              ],
      ),
      body: _Body(
        changes: widget.changes,
        bloc: _clientBloc,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.changes,
    @required this.bloc,
  }) : super(key: key);

  final Map<String, dynamic> changes;
  final ClientBloc bloc;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
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
              stream: widget.bloc.client,
              initialData: ClientInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is ClientInitState) {
                  widget.bloc.loadAllClients();
                  return SizedBox.shrink();
                } else if (snapshot.data is ClientLoadingState) {
                  return _buildLoading();
                } else if (snapshot.data is ClientDataState) {
                  ClientDataState state = snapshot.data;
                  if (state.clients.length > 0)
                    return _buildContent(state.clients);
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

  Widget _buildContent(List<Client> clients) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, i) {
        return _ClientCard(
          client: clients[i],
          changes: widget.changes,
          bloc: widget.bloc,
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
              widget.bloc.loadAllClients();
            },
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatefulWidget {
  const _ClientCard({
    Key key,
    @required this.client,
    @required this.changes,
    @required this.bloc,
  }) : super(key: key);

  final Client client;
  final Map<String, dynamic> changes;
  final ClientBloc bloc;

  @override
  __ClientCardState createState() => __ClientCardState();
}

class __ClientCardState extends State<_ClientCard> {
  String appDocPath;
  Iterable<int> bytes;

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  void init() {
    if (widget.client.avatar != null) {
      if (appDocPath == null) getApplicationDirectoryPath();
      if (widget.client.avatar != null) {
        var hasLocalImage = File(widget.client.avatar).existsSync();
        if (hasLocalImage) {
          bytes = File(widget.client.avatar).readAsBytesSync();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (widget.changes != null)
              ? () {
                  widget.changes['client'] = Client.from(widget.client);
                  widget.changes['onTap']();
                  Navigator.pop(context);
                }
              : () {
                  Navigator.push(
                    context,
                    NextPageRoute(
                      nextPage: ClientInfoScreen(
                        title: 'Клиент',
                        client: widget.client,
                        bloc: widget.bloc,
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
                CircleAvatar(
                  radius: 24.0,
                  backgroundColor: Theme.of(context).focusColor,
                  child: (bytes != null)
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(bytes),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Theme.of(context).cardColor,
                        ),
                ),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(widget.client.name != '') ? (widget.client.name + ' ') : ''}' +
                          '${widget.client.surname ?? ''}'
                              .replaceAll(RegExp(r"\s+"), ""),
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.client.city,
                      style: Theme.of(context).textTheme.subtitle2,
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
