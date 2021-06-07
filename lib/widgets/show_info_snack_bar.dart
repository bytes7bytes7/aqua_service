import 'package:flutter/material.dart';

void showInfoSnackBar({
  @required BuildContext context,
  @required String info,
  @required IconData icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black.withOpacity(0.5),
      duration: const Duration(seconds: 1),
      content: Row(
        children: [
          Text(
            info,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Spacer(),
          Icon(
            icon,
            color: Theme.of(context).cardColor,
          ),
        ],
      ),
    ),
  );
}