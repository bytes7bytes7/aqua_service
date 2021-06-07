import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  const RectButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).focusColor,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline2,
      ),
      onPressed: onPressed,
    );
  }
}
