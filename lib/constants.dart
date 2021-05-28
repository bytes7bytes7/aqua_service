import 'package:flutter/material.dart';

abstract class ConstColors {
  static const Color scaffoldBackgroundColor = Color(0xFF114D5B);
  static const Color cardColor = Color(0xFF04B3AA);
  static const Color headline1Color = Colors.white;
  static const Color focusColor = Colors.white;
  static const Color disabledColor = Color(0xFFCFCFCF);
  static const Color accentColor = Color(0xFF215AFA);
}

abstract class ConstSize {
  static const double menuIconSize = 85.0;
}

abstract class ConstData {
  static const String appTitle = 'Аквариумистика';
  static const Map<String, String> monthsNames = {
    '01': 'Январь',
    '02': 'Февраль',
    '03': 'Март',
    '04': 'Апрель',
    '05': 'Май',
    '06': 'Июнь',
    '07': 'Июль',
    '08': 'Август',
    '09': 'Сентябрь',
    '10': 'Октябрь',
    '11': 'Ноябрь',
    '12': 'Декабрь',
  };
}
