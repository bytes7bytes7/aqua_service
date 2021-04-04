import 'package:flutter/material.dart';
import '../constants.dart';

var darkTheme = ThemeData(
  scaffoldBackgroundColor: ConstColors.scaffoldBackgroundColor,
  primaryColor: ConstColors.cardColor,
  cardColor: ConstColors.cardColor,
  focusColor: ConstColors.focusColor,
  textTheme: TextTheme(
    headline2: TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.w300,
      color:ConstColors.focusColor,
    ),
    headline1 : TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.focusColor,
    ),
  ),
);
