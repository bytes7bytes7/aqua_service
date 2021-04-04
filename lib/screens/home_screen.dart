import 'package:aqua_service/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = 40.0;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 40.0),
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
                      horizontalPadding: horizontalPadding,
                    ),
                    SizedBox(width: 20.0),
                    CardButton(
                      title: 'Работа',
                      horizontalPadding: horizontalPadding,
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
                      horizontalPadding: horizontalPadding,
                    ),
                    SizedBox(width: 20.0),
                    CardButton(
                      title: 'Календарь',
                      horizontalPadding: horizontalPadding,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              CardButton(
                title: 'Отчеты',
                horizontalPadding: horizontalPadding,
                expanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
