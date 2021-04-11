import 'package:aqua_service/bloc/client_bloc.dart';
import 'package:aqua_service/repository/clients_repository.dart';
import 'package:aqua_service/widgets/client_card.dart';
import 'package:aqua_service/widgets/rect_button.dart';
import 'package:aqua_service/widgets/search_bar.dart';
import 'package:aqua_service/widgets/sort_bar.dart';
import '../model/client.dart';
import 'package:flutter/material.dart';
import '../screens/client_info_screen.dart';
import 'global/next_page_route.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen(this._repo);

  final ClientRepository _repo;

  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: _Body(widget._repo),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  const _AppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 4.0,
      centerTitle: true,
      title: Text(
        'Клиенты',
        style: Theme.of(context).textTheme.headline2,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: Theme.of(context).focusColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon:
              Icon(Icons.add, color: Theme.of(context).focusColor, size: 32.0),
          onPressed: () {
            Navigator.push(
              context,
              NextPageRoute(nextPage: ClientInfoScreen(title: 'Новый Клиент')),
            );
          },
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(this._repo);

  final ClientRepository _repo;

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
          SortBar(),
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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(List<Client> clients) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context,i) {
        return ClientCard(
          client: clients[i],
        );
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ошибка',style: Theme.of(context).textTheme.headline1,),
          SizedBox(height: 20),
          RectButton(text: 'Обновить', onPressed: () {
            _clientBloc.loadAllClients();
          }),
        ],
      ),
    );
  }
}
