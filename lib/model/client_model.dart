class Client {
  String name;
  String surname;
  String middleName;
  String city;
  String address;
  String volume;
  String previousDate;
  String nextDate;
  List<String> images;

  Client.fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? '';
    surname = map['surname'] ?? '';
    middleName = map['middleName'] ?? '';
    city = map['city'] ?? '';
    address = map['address'] ?? '';
    volume = map['volume'] ?? '';
    previousDate = map['previousDate'] ?? '';
    nextDate = map['nextDate'] ?? '';
    images = map['images'] ?? [];
  }
}
