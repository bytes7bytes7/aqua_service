import 'package:meta/meta.dart';

class Settings {
  Settings({
    this.id = 1,
    @required this.appTitle,
    @required this.icon,
  });

  int id;
  String appTitle;
  String icon;

  Settings.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    appTitle = map['appTitle'];
    icon = map['icon'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appTitle': appTitle,
      'icon': icon,
    };
  }
}
