import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:mime/mime.dart';

import 'package:aqua_service/bloc/bloc.dart';
import 'package:aqua_service/database/database_helper.dart';
import 'package:aqua_service/model/client.dart';
import 'package:aqua_service/model/fabric.dart';
import 'package:aqua_service/model/order.dart';
import 'package:aqua_service/model/settings.dart';
import 'package:aqua_service/screens/widgets/show_info_snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

abstract class ExcelHelper {
  static readExcel(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    String mimeType = lookupMimeType(result.files.single.path);
    if (mimeType ==
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
      List<Client> clients;
      List<Order> orders;
      List<Fabric> fabrics;
      Settings settings;

      if (result != null) {
        String file = result.files.single.path;
        Iterable<int> bytes = File(file).readAsBytesSync();
        Excel excel = Excel.decodeBytes(bytes);

        Map<String, dynamic> map;
        List<dynamic> headerRow, row;
        for (var table in excel.tables.keys) {
          if (table == ConstDBData.clientTableName ||
              table == ConstDBData.orderTableName ||
              table == ConstDBData.fabrics ||
              table == ConstDBData.settingsTableName) {
            for (int i = 0; i < excel.tables[table].rows.length; i++) {
              if (i > 0) {
                headerRow = excel.tables[table].rows[0];
                row = excel.tables[table].rows[i];
                map = Map<String, dynamic>.fromIterables(
                    headerRow.map<String>((e) => e.toString()), row);
              }
            }
          }
          if (table == ConstDBData.clientTableName) {
            clients = [];
            map['images'] = map['images'] != null
                ? map['images'].toString().split(';')
                : null;
            clients.add(Client.fromMap(map));
          } else if (table == ConstDBData.orderTableName) {
            orders = [];
            map['client'] = Client(id: map['client']);
            map['price'] = double.parse(map['price'].toString());
            map['fabrics'] = map['fabrics'] != null
                ? map['fabrics']
                    .split(';')
                    .map<Fabric>((e) => Fabric(id: int.parse(e)))
                : [];
            map['expenses'] = map['expenses'] != null
                ? double.parse(map['expenses'].toString())
                : null;
            map['date'] = map['date'].toString();
            if (map['date'].contains('T')) {
              map['date'] = map['date'].substring(0, map['date'].indexOf('T'));
            }
            map['done'] = map['done'].toString() == '1' ? true : false;
            orders.add(Order.fromMap(map));
          } else if (table == ConstDBData.fabricTableName) {
            fabrics = [];
            map['retailPrice'] = map['retailPrice'] != null
                ? double.parse(map['retailPrice'].toString())
                : null;
            map['purchasePrice'] = map['purchasePrice'] != null
                ? double.parse(map['purchasePrice'].toString())
                : null;
            fabrics.add(Fabric.fromMap(map));
          } else if (table == ConstDBData.settingsTableName) {
            settings = Settings.fromMap(map);
          }
        }
        Bloc.bloc.settingsBloc.importExcel(clients, fabrics, orders, settings);
        showInfoSnackBar(
          context: context,
          info: 'Данные загружены',
          icon: Icons.done_all_outlined,
        );
      }
    } else {
      showInfoSnackBar(
        context: context,
        info: 'Неверный тип файла',
        icon: Icons.warning_amber_outlined,
      );
    }
  }

  static writeExcel(BuildContext context) async {
    Directory directory = await _createAppDir(context);
    DateTime today = DateTime.now();
    String day = today.day.toString(), month = today.month.toString();
    if (day.length < 2) day = '0' + day;
    if (month.length < 2) month = '0' + month;
    String filePath = '${directory.path}/$day-$month-${today.year}.xlsx';

    ByteData data = await rootBundle.load("assets/xlsx/example.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    // write data
    List<Client> clients = await DatabaseHelper.db.getAllClients();
    List<Order> orders = await DatabaseHelper.db.getAllOrders();
    List<Fabric> fabrics = await DatabaseHelper.db.getAllFabrics();
    Settings settings = await DatabaseHelper.db.getSettings();
    Map<String, dynamic> map;

    for (var table in excel.tables.keys) {
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table].rows) {
          print(row);
        }
      }
      //excel.tables[table].removeRow(1);
      excel.tables[table].clearRow(1);
      if (table == ConstDBData.clientTableName) {
        //excel.tables[table].removeColumn(9);
        for (int i = 0; i < clients.length; i++) {
          map = clients[i].toMap();
          map['images'] = map['images'].isNotEmpty? map['images'].join(';') : null;
          //excel.tables[table].appendRow([1, null, 'name1', 'surname1', 'md', 'city1', 'ad-s', '12312', 10, 'im/im/1.jpg']);
          //excel.tables[table].insertRowIterables(['1','2','3','4','5'], 1);
          excel.tables[table].rows[1].clear();
          excel.tables[table].rows[1].addAll([1, null, 'name1', 'surname1', 'md', 'city1', 'ad-s', '12312', 10, 'im/im/1.jpg']);
        }

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table].rows) {
            print(row);
          }
        }
        // } else if (table == ConstDBData.fabricTableName) {
        //   for (int i = 0; i < fabrics.length; i++) {
        //     map = fabrics[i].toMap();
        //     excel.tables[table].insertRowIterables(map.values.toList(), i + 1);
        //   }
        // } else if (table == ConstDBData.orderTableName) {
        //   for (int i = 0; i < orders.length; i++) {
        //     map = orders[i].toMap();
        //     excel.tables[table].insertRowIterables(map.values.toList(), i + 1);
        //   }
        // } else if (table == ConstDBData.settingsTableName) {
        //   map = settings.toMap();
        //   excel.tables[table].insertRowIterables(map.values.toList(), 1);
      }
    }

    excel.encode().then((onValue) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) return true;
    var result = await permission.request();
    if (result == PermissionStatus.granted) return true;
    return false;
  }

  static Future<Directory> _createAppDir(BuildContext context) async {
    Directory directory;
    try {
      if (await _requestPermission(Permission.storage)) {
        directory = await getExternalStorageDirectory();
        String newPath = '';
        for (String p in directory.path.split('/')) {
          if (p == 'Android')
            break;
          else if (p.isNotEmpty) newPath += '/' + p;
        }
        newPath += '/AquaService';
        directory = Directory(newPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          return directory;
        }
      }
    } catch (error) {
      showInfoSnackBar(
        context: context,
        info: 'Ошибка',
        icon: Icons.warning_amber_outlined,
      );
    }
    return null;
  }
}
