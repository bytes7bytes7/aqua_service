import 'package:aqua_service/repository/repository.dart';
import 'package:collection/collection.dart';

import 'order.dart';

class Client {
  Client({
    this.id,
    this.avatar,
    this.name,
    this.surname,
    this.middleName,
    this.city,
    this.address,
    this.phone,
    this.volume,
    this.previousDate,
    this.nextDate,
    List<String> images,
  }) : images = images ?? [];

  // To store String in db, first I need to convert String to Uint8List by this way:
  // List<int> list = 'xxx'.codeUnits;
  // Uint8List bytes = Uint8List.fromList(list);
  // String string = String.fromCharCodes(bytes);

  int id;
  String avatar;
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

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    return (other.id == id &&
        other.avatar == avatar &&
        other.name == name &&
        other.surname == surname &&
        other.middleName == middleName &&
        other.city == city &&
        other.address == address &&
        other.phone == phone &&
        other.volume == volume &&
        other.previousDate == previousDate &&
        other.nextDate == nextDate &&
        ListEquality().equals(other.images, images));
  }

  Client.from(Client other) {
    id = other.id;
    avatar = other.avatar;
    name = other.name;
    surname = other.surname;
    middleName = other.middleName;
    city = other.city;
    address = other.address;
    phone = other.phone;
    volume = other.volume;
    previousDate = other.previousDate;
    nextDate = other.nextDate;
    images = List<String>.from(other.images);
  }

  Client.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    avatar = map['avatar'];
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
    return {
      'id': id,
      'avatar': avatar,
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
  }

  Future<List<Order>> getDates(int id) async {
    List<Order> orders = await Repository.orderRepository.getAllOrders();
    Order last, next;
    orders.forEach((element) {
      if(element.done && element.id == id){
       if (last==null || last.date.compareTo(element.date) < 0){
         last=Order.from(element);
       }
      }else if(!element.done  && element.id == id){
        if(next==null || next.date.compareTo(element.date)>0){
          next=Order.from(element);
        }
      }
    });
    if(last!=null){
      List<String> tmp = last.date.split('.');
      last.date = '${tmp[2]}.${tmp[1]}.${tmp[0]}';
    }
    if(next!=null){
      List<String> tmp = next.date.split('.');
      next.date = '${tmp[2]}.${tmp[1]}.${tmp[0]}';
    }
    return [last,next];
  }
}
