import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    Key key,
    @required this.title,
    @required this.horizontalPadding,
    this.expanded=false,
  }) : super(key: key);

  final String title;
  final double horizontalPadding;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: [Theme
                  .of(context)
                  .cardColor, Colors.transparent],
              begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .headline2,
          ),
        ),
      ),
    );
  }
}
