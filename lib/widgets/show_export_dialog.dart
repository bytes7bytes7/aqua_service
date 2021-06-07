import 'package:flutter/material.dart';

import '../services/value_validation.dart';
import '../services/excel_helper.dart';

Future<void> showExportDialog(
    {BuildContext context, Function onDone}) async {
  DateTime today = DateTime.now();
  String day = today.day.toString(), month = today.month.toString();
  if (day.length < 2) day = '0' + day;
  if (month.length < 2) month = '0' + month;
  String name = '${today.year}-$month-$day';
  final TextEditingController controller = TextEditingController(text: name);
  final ValueNotifier<String> errorNotifier = ValueNotifier(null);
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // true - user can dismiss dialog
    builder: (BuildContext context) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Экспорт',
            style: Theme.of(context).textTheme.headline2,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controller,
                    style: Theme.of(context).textTheme.bodyText1,
                    validator: (value) {
                      if (errorNotifier.value != null) {
                        return 'Недопустимо: ${errorNotifier.value}';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Название файла',
                      labelStyle: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Отмена',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).cardColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Готово',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).cardColor),
              ),
              onPressed: () {
                errorNotifier.value = filenameValidation(controller.text);
                if (errorNotifier.value != null) {
                  _formKey.currentState.validate();
                } else {
                  errorNotifier.value = null;
                  ExcelHelper.exportToExcel(context, controller.text);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}