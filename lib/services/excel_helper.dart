import 'dart:io';
import 'package:aqua_service/bloc/bloc.dart';
import 'package:aqua_service/constants.dart';
import 'package:aqua_service/model/client.dart';
import 'package:aqua_service/model/fabric.dart';
import 'package:aqua_service/model/order.dart';
import 'package:aqua_service/model/settings.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:mime/mime.dart';

import 'package:aqua_service/screens/widgets/show_info_snack_bar.dart';

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
          print('\n\nTABLE: $table');
          print('MAX COLS: ${excel.tables[table].maxCols}');
          print('MAX ROWS: ${excel.tables[table].maxRows}');
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
            map['volume'] = map['volume'] != null
                ? double.parse(map['volume'].toString())
                : null;
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
      }
    } else {
      showInfoSnackBar(
        context: context,
        info: 'Неверный тип файла',
        icon: Icons.warning_amber_outlined,
      );
    }
  }
}
