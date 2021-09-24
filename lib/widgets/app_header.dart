import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  const AppHeader({
    Key? key,
    required this.title,
    this.action,
    this.leading,
  }) : super(key: key);

  final String title;
  final List<Widget>? action;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AppBar(
        elevation: 4.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
        leading: leading ?? IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: action,
      ),
    );
  }
}
