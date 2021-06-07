import 'package:flutter/material.dart';

import 'rect_button.dart';

class ErrorLabel extends StatelessWidget {
  const ErrorLabel({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 20),
          RectButton(
            text: 'Обновить',
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
