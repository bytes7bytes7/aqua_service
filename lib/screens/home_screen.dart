import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../widgets/empty_label.dart';
import '../widgets/error_label.dart';
import '../widgets/loading_circle.dart';
import '../bloc/bloc.dart';
import '../bloc/settings_bloc.dart';
import '../constants.dart';
import '../model/settings.dart';
import 'global/next_page_route.dart';
import 'screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          child: StreamBuilder(
            stream: Bloc.bloc.settingsBloc.settings,
            initialData: SettingsInitState(),
            builder: (context, snapshot) {
              if (snapshot.data is SettingsInitState) {
                Bloc.bloc.settingsBloc.loadAllSettings();
                return SizedBox.shrink();
              } else if (snapshot.data is SettingsLoadingState) {
                return LoadingCircle();
              } else if (snapshot.data is SettingsDataState) {
                SettingsDataState state = snapshot.data as SettingsDataState;
                Settings? settings = state.settings;
                if (state.settings != null) {
                  return _ContentList(
                    settings: settings!,
                    bytes: state.bytes,
                  );
                } else {
                  return EmptyLabel();
                }
              } else {
                return ErrorLabel(
                  error: snapshot.error as Error,
                  stackTrace: snapshot.stackTrace as StackTrace,
                  onPressed: () {
                    Bloc.bloc.settingsBloc.loadAllSettings();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList({
    Key? key,
    required this.settings,
    required this.bytes,
  }) : super(key: key);

  final Settings settings;
  final Iterable<int>? bytes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Flexible(
          flex: 4,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  NextPageRoute(
                    nextPage: SettingsScreen(settings: settings),
                  ),
                );
              },
              child: Container(
                child: (settings.icon != null && bytes != null)
                    ? Image.memory(bytes as Uint8List)
                    : Image.asset('assets/png/logo.png'),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          settings.appTitle ?? ConstData.appTitle,
          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 35),
        ),
        SizedBox(height: 50),
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
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    Key? key,
    required this.title,
    required this.route,
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
