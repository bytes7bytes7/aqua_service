// import 'dart:async';
import 'package:aqua_service/bloc/client_bloc.dart';
import 'package:aqua_service/repository/clients_repository.dart';

// import '../model/client_model.dart';
import '../model/client.dart';
import 'package:flutter/material.dart';
import '../screens/client_info_screen.dart';
// import '../widgets/client_card.dart';
// import '../widgets/search_bar.dart';
// import '../widgets/sort_bar.dart';
import 'global/next_page_route.dart';
// import 'package:aqua_service/test_data.dart';

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
    print('asdas');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
        child: StreamBuilder(
          stream: _clientBloc.client,
          initialData: ClientInitState(),
          builder: (context, snapshot) {
            if (snapshot.data is ClientInitState) {
              _clientBloc.loadClient();
              return SizedBox.shrink();
            } else if (snapshot.data is ClientDataState) {
              ClientDataState state = snapshot.data;
              return _buildContent(state.client);
            } else if (snapshot.data is ClientLoadingState) {
              return _buildLoading();
            } else {
              return _buildError();
            }
          },
        ),
      ),
    );
  }

  // Widget _buildInit() {
  //   return Center(
  //     child: OutlinedButton(
  //       child: const Text('Load'),
  //       onPressed: () {
  //
  //       },
  //     ),
  //   );
  // }

  Widget _buildContent(Client client) {
    return Center(
      child: Text('${client.name} ${client.surname} ${client.city}'),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Column(
      children: [
        Center(
          child: Text('Error'),
        ),
      ],
    );
  }
}
