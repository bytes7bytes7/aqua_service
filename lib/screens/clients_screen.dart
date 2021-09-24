import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/app_header.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/client_bloc.dart';
import '../model/client.dart';
import 'global/next_page_route.dart';
import 'client_info_screen.dart';

class ClientsScreen extends StatefulWidget {
  ClientsScreen({
    Key? key,
    this.updateClient,
  }) : super(key: key);

  final Function? updateClient;

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
    Key? key,
    this.updateClient,
  }) : super(key: key);

  final Function? updateClient;

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
            ClientDataState state = snapshot.data as ClientDataState;
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
              error: snapshot.error as Error,
              stackTrace: snapshot.stackTrace as StackTrace,
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
    Key? key,
    required this.clients,
    required this.updateClient,
  }) : super(key: key);

  final List<Client> clients;
  final Function? updateClient;

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
    Key? key,
    required this.client,
    this.updateClient,
  }) : super(key: key);

  final Client client;
  final Function? updateClient;

  @override
  __ClientCardState createState() => __ClientCardState();
}

class __ClientCardState extends State<_ClientCard> {
  Iterable<int>? bytes;

  void init() {
    if (widget.client.avatar != null) {
      if (widget.client.avatar != null) {
        var hasLocalImage = File(widget.client.avatar!).existsSync();
        if (hasLocalImage) {
          bytes = File(widget.client.avatar!).readAsBytesSync();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (widget.updateClient != null)
              ? () {
                  widget.updateClient!(widget.client);
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
                (widget.client.avatar != null && bytes != null)
                    ? ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(width: 50, height: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(bytes as Uint8List),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : (widget.client.avatar != null)
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
                SizedBox(width: 14.0),
                Container(
                  width: size.width*0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(widget.client.name != '') ? (widget.client.name! + ' ') : ''}' +
                            '${widget.client.surname ?? ''}'
                                .replaceAll(RegExp(r"\s+"), ""),
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        widget.client.city!,
                        style: Theme.of(context).textTheme.subtitle2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
