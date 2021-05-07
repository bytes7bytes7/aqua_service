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
  String date; // dd-MM-yyyy
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
}
