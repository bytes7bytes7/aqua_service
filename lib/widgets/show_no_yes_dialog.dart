import 'package:flutter/material.dart';

Future<void> showNoYesDialog({required BuildContext context, required String title, required String subtitle, required Function noAnswer, required Function yesAnswer}) async {
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
                  .bodyText1!
                  .copyWith(color: Theme.of(context).cardColor),
            ),
            onPressed: noAnswer as void Function()?,
          ),
          TextButton(
            child: Text(
              'Да',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Theme.of(context).cardColor),
            ),
            onPressed: yesAnswer as void Function()?,
          ),
        ],
      );
    },
  );
}