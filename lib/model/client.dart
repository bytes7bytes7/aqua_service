import 'package:flutter/material.dart';

class Client {
  Client({
    @required this.name,
    @required this.surname,
    this.middleName,
    @required this.city,
    this.address,
    this.volume,
    this.previousDate,
    this.nextDate,
    this.images,
  });

  String name;
  String surname;
  String middleName;
  String city;
  String address;
  String volume;
  String previousDate;
  String nextDate;
  List<String> images;
}
