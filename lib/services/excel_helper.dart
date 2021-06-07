import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:mime/mime.dart';

import '../model/client.dart';
import '../model/fabric.dart';
import '../model/order.dart';
import '../model/settings.dart';
import '../bloc/bloc.dart';
import '../database/database_helper.dart';
import '../widgets/show_info_snack_bar.dart';
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

  static exportToExcel(BuildContext context, String filename) async {
    Directory directory = await _createAppDir(context);
    String filePath = '${directory.path}/$filename.xlsx';

    // Init excel
    Excel excel = Excel.createExcel();
    excel.copy('Sheet1', ConstDBData.clientTableName);
    excel.copy('Sheet1', ConstDBData.orderTableName);
    excel.copy('Sheet1', ConstDBData.fabricTableName);
    excel.copy('Sheet1', ConstDBData.settingsTableName);
    excel.delete('Sheet1');

    // Get data
    List<Client> clients = await DatabaseHelper.db.getAllClients();
    List<Order> orders = await DatabaseHelper.db.getAllOrders();
    List<Fabric> fabrics = await DatabaseHelper.db.getAllFabrics();
    Settings settings = await DatabaseHelper.db.getSettings();

    List<String> headerRow;

    // Fill table with data
    for (var table in excel.tables.keys) {
      var thisTable = excel.tables[table];
      if (table == ConstDBData.clientTableName) {
        headerRow = [
          ConstDBData.id,
          ConstDBData.avatar,
          ConstDBData.name,
          ConstDBData.surname,
          ConstDBData.middleName,
          ConstDBData.city,
          ConstDBData.address,
          ConstDBData.phone,
          ConstDBData.volume,
          ConstDBData.images,
        ];
        thisTable.appendRow(headerRow);
        for (int i = 0; i < clients.length; i++) {
          if (clients[i].images.isEmpty) {
            clients[i].images = null;
          }
          thisTable.appendRow(clients[i].toMap().values.toList());
        }
      } else if (table == ConstDBData.orderTableName) {
        headerRow = [
          ConstDBData.id,
          ConstDBData.client,
          ConstDBData.price,
          ConstDBData.fabrics,
          ConstDBData.expenses,
          ConstDBData.date,
          ConstDBData.done,
          ConstDBData.comment,
        ];
        thisTable.appendRow(headerRow);
        for (int i = 0; i < orders.length; i++) {
          if (orders[i].fabrics.isEmpty) {
            orders[i].fabrics = null;
          }
          List<dynamic> values = orders[i].toMap().values.toList();
          values[1] = values[1].id; // Client id
          if (values[3] != null) {
            values[3] = values[3].map((e) => e.id).join(';'); // Fabrics' ids
          }
          thisTable.appendRow(values);
        }
      } else if (table == ConstDBData.fabricTableName) {
        headerRow = [
          ConstDBData.id,
          ConstDBData.title,
          ConstDBData.retailPrice,
          ConstDBData.purchasePrice,
        ];
        thisTable.appendRow(headerRow);
        for (int i = 0; i < fabrics.length; i++) {
          thisTable.appendRow(fabrics[i].toMap().values.toList());
        }
      } else if (table == ConstDBData.settingsTableName) {
        headerRow = [
          ConstDBData.id,
          ConstDBData.appTitle,
          ConstDBData.icon,
        ];
        thisTable.appendRow(headerRow);
        thisTable.appendRow(settings.toMap().values.toList());
      }

      // Correct quantity of columns
      if (table == ConstDBData.clientTableName ||
          table == ConstDBData.orderTableName ||
          table == ConstDBData.fabrics ||
          table == ConstDBData.settingsTableName) {
        for (int i = 0; i < thisTable.rows.length; i++) {
          while (thisTable.rows[i].length > headerRow.length) {
            thisTable.removeColumn(thisTable.rows[i].length - 1);
          }
        }
      }
    }

    // Print result
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        print(row);
      }
    }

    // Save excel
    excel.encode().then(
      (onValue) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      },
    );
    showInfoSnackBar(
      context: context,
      info: 'Готово',
      icon: Icons.done_all_outlined,
    );
    Navigator.pop(context);
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
