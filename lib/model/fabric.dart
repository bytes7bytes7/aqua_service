class Fabric {
  Fabric({
    this.id,
    this.title,
    this.retailPrice,
    this.purchasePrice,
  });

  int id;
  String title;
  double retailPrice;
  double purchasePrice;

  Fabric.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    retailPrice = map['retailPrice'];
    purchasePrice = map['purchasePrice'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'title': title,
      'retailPrice': retailPrice,
      'purchasePrice': purchasePrice,
    };
  }
}
