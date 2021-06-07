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
  static const String forbiddenFileCharacters = r'\/:*?"<>|+%!@';
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

abstract class ConstDBData {
  static final databaseName = "data.db";
  // Increment this version when you need to change the schema.
  static final databaseVersion = 1;

  // Names of tables
  static const String clientTableName = 'clients';
  static const String orderTableName = 'orders';
  static const String fabricTableName = 'fabrics';
  static const String settingsTableName = 'settings';

  // Special columns for clients
  static const String id = 'id';
  static const String avatar = 'avatar';
  static const String name = 'name';
  static const String surname = 'surname';
  static const String middleName = 'middleName';
  static const String city = 'city';
  static const String address = 'address';
  static const String phone = 'phone';
  static const String volume = 'volume';
  // static const String previousDate = 'previousDate';
  // static const String nextDate = 'nextDate';
  static const String images = 'images';

  // Special columns for fabrics
  static const String title = 'title';
  static const String retailPrice = 'retailPrice';
  static const String purchasePrice = 'purchasePrice';

  static const String client = 'client'; // contains only client id (Exp: 1)
  static const String price = 'price';
  static const String fabrics =
      'fabrics'; // contains only string of fabric ids (Exp: 1;2;3)
  static const String expenses = 'expenses';
  static const String date = 'date';
  static const String done = 'done';
  static const String comment = 'comment';

  // Special for settings
  static const String appTitle = 'appTitle';
  static const String icon = 'icon';
}