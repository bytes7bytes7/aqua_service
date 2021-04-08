import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(68.0),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            Theme.of(context).cardColor.withOpacity(0)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(),
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                hintText: 'Поиск...',
                hintStyle: Theme.of(context).textTheme.headline3,
                contentPadding: const EdgeInsets.all(0),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(
            Icons.search,
            color: Theme.of(context).focusColor,
            size: 22.0,
          ),
        ],
      ),
    );
  }
}
