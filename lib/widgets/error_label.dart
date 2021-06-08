import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'show_info_snack_bar.dart';
import 'rect_button.dart';

class ErrorLabel extends StatelessWidget {
  const ErrorLabel({
    Key key,
    @required this.error,
    @required this.stackTrace,
    @required this.onPressed,
  }) : super(key: key);

  final Error error;
  final StackTrace stackTrace;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    String _error = 'ERROR:\n $error';
    String _stackTrace = '\nStackTrace:\n $stackTrace';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка',
            style: Theme.of(context).textTheme.headline2,
          ),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Theme.of(context).focusColor,
              ),
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Text(
                      _error,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      _stackTrace,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.copy_outlined),
                    color: Theme.of(context).focusColor,
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: '$_error$_stackTrace'),
                      );
                      showInfoSnackBar(
                        context: context,
                        info: 'Скопировано',
                        icon: Icons.done_all_outlined,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          RectButton(
            text: 'Обновить',
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
