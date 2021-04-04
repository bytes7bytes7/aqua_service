import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    Key key,
    @required this.title,
    @required this.route,
  }) : super(key: key);

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
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
        ),
      ),
    );
  }
}
