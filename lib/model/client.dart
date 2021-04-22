class Client {
  Client({
    this.id,
    this.name,
    this.surname,
    this.middleName,
    this.city,
    this.address,
    this.phone,
    this.volume,
    this.previousDate,
    this.nextDate,
    this.images,
  });

  int id;
  String name;
  String surname;
  String middleName;
  String city;
  String address;
  String phone;
  String volume;
  String previousDate;
  String nextDate;
  List<String> images;

  Client.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    surname = map['surname'];
    middleName = map['middleName'];
    city = map['city'];
    address = map['address'];
    phone = map['phone'];
    volume = map['volume'];
    previousDate = map['previousDate'];
    nextDate = map['nextDate'];
    images = map['images'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'surname': surname,
      'middleName': middleName,
      'city': city,
      'address': address,
      'phone': phone,
      'volume': volume,
      'previousDate': previousDate,
      'nextDate': nextDate,
      'images': images,
    };
    return map;
  }
}
