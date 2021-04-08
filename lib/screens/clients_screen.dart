import 'package:flutter/material.dart';
import '../screens/client_info_screen.dart';
import '../widgets/client_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/sort_bar.dart';
import 'global/next_page_route.dart';
import 'package:aqua_service/test_data.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: _Body(),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
        child: ListView.builder(
          itemCount: clients.length+2,
          itemBuilder: (context, i) {
            switch (i) {
              case 0:
                return SearchBar();
                break;
              case 1:
                return SortBar();
                break;
              // case (clients.length-2):
              //   return Padding(
              //     padding: const EdgeInsets.only(top: 10.0,bottom: 20.0),
              //     child: Center(
              //       child: Text(
              //         'Контакты: 37',
              //         style: Theme.of(context).textTheme.subtitle1,
              //       ),
              //     ),
              //   );
              default:
                return ClientCard(client: clients[i-2],);
            }
          },
        ),
      ),
    );
  }
}
