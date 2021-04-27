import 'package:flutter/material.dart';

Future<void> showNoYesDialog({BuildContext context, String title, String subtitle, Function noAnswer, Function yesAnswer}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // true - user can dismiss dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Нет',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).cardColor),
            ),
            onPressed: noAnswer,
          ),
          TextButton(
            child: Text(
              'Да',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).cardColor),
            ),
            onPressed: yesAnswer,
          ),
        ],
      );
    },
  );
}