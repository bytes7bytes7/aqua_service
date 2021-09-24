class Fabric {
  Fabric({
    this.id,
    this.title,
    this.retailPrice,
    this.purchasePrice,
  });

  int? id;
  String? title;
  double? retailPrice;
  double? purchasePrice;

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    return (other is Fabric &&
        other.id == id &&
        other.title == title &&
        other.retailPrice == retailPrice &&
        other.purchasePrice == purchasePrice);
  }

  Fabric.from(Fabric other) {
    id = other.id;
    title = other.title;
    retailPrice = other.retailPrice;
    purchasePrice = other.purchasePrice;
  }

  Fabric.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    retailPrice = map['retailPrice'];
    purchasePrice = map['purchasePrice'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'retailPrice': retailPrice,
      'purchasePrice': purchasePrice,
    };
  }
}
