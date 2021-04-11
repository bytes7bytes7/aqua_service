
import 'package:aqua_service/repository/repository.dart';
import 'package:flutter/material.dart';
import '../screens/global/next_page_route.dart';
import 'package:aqua_service/screens/screens.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    Key key,
    @required this.title,
    @required this.route,
    @required this.repo,
  }) : super(key: key);

  final String title;
  final String route;
  final Repository repo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Widget page;
            switch (route) {
              case '/clients':
                page = ClientsScreen(repo);
                break;
              case '/work':
                page = WorkScreen();
                break;
              case '/material':
                page = MaterialScreen();
                break;
              case '/calendar':
                page = CalendarScreen();
                break;
              case '/reports':
                page = ReportsScreen();
                break;
              default:
                page = Page404();
            }
            Navigator.push(
              context,
              NextPageRoute(nextPage: page),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
