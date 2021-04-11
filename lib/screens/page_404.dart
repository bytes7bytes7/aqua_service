import 'package:flutter/material.dart';

import '../screens/widgets/app_header.dart';

class Page404 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Ошибка'),
      body: Center(
        child: Text(
          'Страница не найдена :(',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
