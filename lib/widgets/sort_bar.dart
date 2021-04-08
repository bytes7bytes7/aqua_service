import 'package:flutter/material.dart';

class SortBar extends StatefulWidget {
  @override
  _SortBarState createState() => _SortBarState();
}

class _SortBarState extends State<SortBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15.0),
        child: Row(
          children: [
            Text(
              'Контакты: 37',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Spacer(),
            Text(
              'Сортировка: А-Я',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(width: 8.0),
            Icon(
              Icons.sort_outlined,
              size: 20.0,
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
