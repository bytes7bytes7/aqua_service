import 'package:flutter/material.dart';

class EmptyLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Пусто',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}
