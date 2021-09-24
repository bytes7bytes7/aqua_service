import 'package:flutter/cupertino.dart';

class NextPageRoute extends CupertinoPageRoute {
  NextPageRoute({required this.nextPage})
      : super(builder: (BuildContext context) => nextPage);

  Widget nextPage;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Animation<double> curve =
        CurvedAnimation(parent: controller!, curve: Curves.linear);
    return FadeTransition(opacity: curve, child: nextPage);
  }
}
