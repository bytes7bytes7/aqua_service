import 'package:aqua_service/model/client.dart';
import 'package:aqua_service/screens/client_info_screen.dart';
import 'package:aqua_service/screens/global/next_page_route.dart';
import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({Key key, this.client}) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 28.0),
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
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).cardColor,
                  ),
                  backgroundColor: Theme.of(context).focusColor,
                ),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(client.name != '') ? (client.name + ' ') : ''}' +
                          '${client.surname ?? ''}'
                              .replaceAll(RegExp(r"\s+"), ""),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      client.city,
                      style: Theme.of(context).textTheme.subtitle2,
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
