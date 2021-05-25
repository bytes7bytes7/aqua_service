import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../database/database_helper.dart';
import 'global/next_page_route.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Flexible(
                flex: 4,
                child: SvgPicture.asset('assets/svg/logo.svg'),
              ),
              // TextButton(
              //   onPressed: () {
              //     DatabaseHelper.db.dropBD();
              //   },
              //   child: Text('Drop DB'),
              // ),
              SizedBox(height: 10),
              Text(
                'Аквариумистика',
                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 35),
              ),
              SizedBox(height: 20),
              // Flexible(
              //   flex: 4,
              //   child: SvgPicture.asset('assets/svg/label.svg'),
              // ),
              SizedBox(height: 30.0),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    _CardButton(
                      title: 'Клиенты',
                      route: '/clients',
                    ),
                    SizedBox(width: 20.0),
                    _CardButton(
                      title: 'Работа',
                      route: '/work',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    _CardButton(
                      title: 'Материалы',
                      route: '/material',
                    ),
                    SizedBox(width: 20.0),
                    _CardButton(
                      title: 'Календарь',
                      route: '/calendar',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _CardButton(
                      title: 'Отчеты',
                      route: '/reports',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    Key key,
    @required this.title,
    @required this.route,
  }) : super(key: key);

  final String title;
  final String route;

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
                page = ClientsScreen();
                break;
              case '/work':
                page = OrdersScreen();
                break;
              case '/material':
                page = FabricsScreen();
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
