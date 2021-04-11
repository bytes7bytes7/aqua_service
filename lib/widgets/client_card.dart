import 'package:flutter/material.dart';
import 'package:aqua_service/model/client.dart';
import '../screens/client_info_screen.dart';
import 'package:aqua_service/screens/global/next_page_route.dart';

class ClientCard extends StatelessWidget {
  ClientCard({Key key, @required this.client}) : super(key: key);

  final Client client;

  void _showPopupMenu(BuildContext context, Offset offset) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 40, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: Text("View"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("Delete"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(
              context,
              NextPageRoute(
                  nextPage: ClientInfoScreen(
                title: 'Клиент',
                client: client,
              )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).focusColor,
                child: Icon(
                  Icons.person_outline_outlined,
                  color: Theme.of(context).cardColor,
                ),
              ),
              title: Text(
                '${(client.name != '') ? (client.name + ' ') : ''}' +
                    '${client.surname ?? ''}'.replaceAll(RegExp(r"\s+"), ""),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text(
                client.city ?? '',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 14.0),
              ),
              trailing: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showPopupMenu(context,details.globalPosition);
                },
                child: Icon(Icons.more_vert),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
