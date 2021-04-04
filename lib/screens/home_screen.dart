import 'package:aqua_service/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 40.0, vertical: 40.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              SvgPicture.asset('assets/svg/logo.svg'),
              SizedBox(height: 20.0),
              Text(
                'Aqua Service',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 60.0),
              Expanded(
                child: Row(
                  children: [
                    CardButton(
                      title: 'Клиенты',
                      route: '/clients',
                    ),
                    SizedBox(width: 20.0),
                    CardButton(
                      title: 'Работа',
                      route: '/work',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: Row(
                  children: [
                    CardButton(
                      title: 'Материалы',
                      route: '/material',
                    ),
                    SizedBox(width: 20.0),
                    CardButton(
                      title: 'Календарь',
                      route: '/calendar',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              CardButton(
                title: 'Отчеты',
                route: '/reports',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
