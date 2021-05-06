import 'package:flutter/material.dart';
import '../constants.dart';

var darkTheme = ThemeData(
  scaffoldBackgroundColor: ConstColors.scaffoldBackgroundColor,
  accentColor: ConstColors.accentColor,
  primaryColor: ConstColors.cardColor,
  cardColor: ConstColors.cardColor,
  focusColor: ConstColors.focusColor,
  disabledColor: ConstColors.disabledColor,
  textTheme: TextTheme(
    headline1: TextStyle(
      fontSize: 35.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.focusColor,
    ),
    headline2: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.focusColor,
    ),
    headline3: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.disabledColor,
    ),
    bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.focusColor,
    ),
    subtitle1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.disabledColor,
    ),
    subtitle2: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
      color: ConstColors.focusColor,
    ),
  ),
);
