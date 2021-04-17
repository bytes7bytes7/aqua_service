import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'fabric.dart';
import 'client.dart';

class Order {
  Order({
    @required this.client,
    this.price=0,
    this.fabrics,
    this.expenses=0,
    @required this.date,
    this.done = false,
    this.comment = '',
  });

  final Client client;
  final double price;
  final List<Fabric> fabrics;
  final double expenses;
  // YY-MM-DD
  final String date;
  final bool done;
  final String comment;

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
