import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'fabric.dart';
import 'client.dart';

class Order {
  Order({
    this.id,
    @required this.client,
    this.price=0,
    this.fabrics,
    this.expenses=0,
    @required this.date,
    this.done = false,
    this.comment = '',
  });

  int id;
  Client client;
  double price;
  List<Fabric> fabrics;
  double expenses;
  // YY-MM-DD
  String date;
  bool done;
  String comment;

  String dateToString({String year,String month, String day}){
    while(year.length < 4)
      year ='0'+year;
    while(month.length < 2)
      month = '0'+month;
    while(day.length < 2)
      day = '0'+day;
    return year+month+day;
  }
}
