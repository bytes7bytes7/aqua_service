import 'dart:io';
import 'package:aqua_service/screens/widgets/empty_label.dart';
import 'package:aqua_service/screens/widgets/error_label.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/app_header.dart';
import 'widgets/rect_button.dart';
import 'widgets/loading_circle.dart';
import 'global/next_page_route.dart';
import '../model/client.dart';
import 'client_info_screen.dart';
import '../bloc/bloc.dart';
import '../bloc/client_bloc.dart';

class ClientsScreen extends StatefulWidget {
  ClientsScreen({
    Key key,
    this.updateClient,
  }) : super(key: key);

  final Function updateClient;

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Клиенты',
        action: (widget.updateClient != null)
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
                        ),
                      ),
                    );
                  },
                ),
              ],
      ),
      body: _Body(
        updateClient: widget.updateClient,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    this.updateClient,
  }) : super(key: key);

  final Function updateClient;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  void dispose() {
    Bloc.bloc.clientBloc.dispose();
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
        stream: Bloc.bloc.clientBloc.client,
        initialData: ClientInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is ClientInitState) {
            Bloc.bloc.clientBloc.loadAllClients();
            return SizedBox.shrink();
          } else if (snapshot.data is ClientLoadingState) {
            return LoadingCircle();
          } else if (snapshot.data is ClientDataState) {
            ClientDataState state = snapshot.data;
            if (state.clients.length > 0) {
              return _ContentList(
                clients: state.clients,
                updateClient: widget.updateClient,
              );
            } else {
              return EmptyLabel();
            }
          } else {
            return ErrorLabel(
              onPressed: () {
                Bloc.bloc.clientBloc.loadAllClients();
              },
            );
          }
        },
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList({
    Key key,
    @required this.clients,
    @required this.updateClient,
  }) : super(key: key);

  final List<Client> clients;
  final Function updateClient;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, i) {
        return _ClientCard(
          client: clients[i],
          updateClient: updateClient,
        );
      },
    );
  }
}

class _ClientCard extends StatefulWidget {
  const _ClientCard({
    Key key,
    @required this.client,
    this.updateClient,
  }) : super(key: key);

  final Client client;
  final Function updateClient;

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
          onTap: (widget.updateClient != null)
              ? () {
                  widget.updateClient(widget.client);
                  Navigator.pop(context);
                }
              : () {
                  Navigator.push(
                    context,
                    NextPageRoute(
                      nextPage: ClientInfoScreen(
                        title: 'Клиент',
                        client: widget.client,
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
