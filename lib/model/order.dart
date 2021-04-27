class Order {
  Order({
    this.id,
    this.clientId,
    this.price,
    this.fabricIds,
    this.expenses,
    this.date,
    this.done,
    this.comment,
  });

  int id;
  int clientId;
  double price;
  List<int> fabricIds;
  double expenses;
  String date; // YY-MM-DD
  bool done;
  String comment;

  Order.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    clientId = map['clientId'];
    price = map['price'];
    fabricIds = map['fabricIds'];
    expenses = map['expenses'];
    date = map['date'];
    done = map['done'];
    comment = map['comment'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'clientId':clientId,
      'price':price,
      'fabricIds':fabricIds,
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
