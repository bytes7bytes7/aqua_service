import 'client.dart';
import 'fabric.dart';

class Order {
  Order({
    this.id,
    Client client,
    this.price,
    this.fabrics,
    this.expenses,
    this.date,
    this.done,
    this.comment,
  });

  int id;
  Client client;
  double price;
  List<Fabric> fabrics;
  double expenses;
  String date; // YY-MM-DD
  bool done;
  String comment;

  Order.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    client = map['client'];
    price = map['price'];
    fabrics = map['fabrics'].map<Fabric>((e) => Fabric.from(e)).toList();
    expenses = map['expenses'];
    date = map['date'];
    done = map['done']==1 ? true : false;
    comment = map['comment'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'client':client,
      'price':price,
      'fabrics':fabrics,
      'expenses':expenses,
      'date':date,
      'done':done,
      'comment':comment,
    };
  }

  String dateToString({String year, String month, String day}) {
    while (year.length < 4) year = '0' + year;
    while (month.length < 2) month = '0' + month;
    while (day.length < 2) day = '0' + day;
    return year + month + day;
  }
}
