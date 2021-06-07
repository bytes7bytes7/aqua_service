import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

import '../model/client.dart';
import '../model/fabric.dart';
import '../model/order.dart';
import '../model/settings.dart';
import '../bloc/bloc.dart';
import '../database/database_helper.dart';
import '../widgets/show_info_snack_bar.dart';
import '../constants.dart';

abstract class ExcelHelper {
  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) return true;
    var result = await permission.request();
    if (result == PermissionStatus.granted) return true;
    return false;
  }

  static Future<Directory> getPhotosDirectory(BuildContext context) async {
    Directory directory = await _getApplicationDirectory(context);
    String photosPath = directory.path + '/Photos';
    directory = Directory(photosPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static Future<Directory> _getApplicationDirectory(BuildContext context) async {
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

  static exportToExcel(BuildContext context, String filename) async {
    Directory directory = await _getApplicationDirectory(context);
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
      List<dynamic> values;
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
          values = clients[i].toMap().values.toList();
          // avatar
          if (values[1] == null) {
            values[1] = '';
          }
          // images
          if (values[9].isEmpty) {
            values[9] = '';
          } else {
            values[9] = values[9].join(';');
          }
          thisTable.appendRow(values);
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
          values = orders[i].toMap().values.toList();
          // Client id
          values[1] = values[1].id;
          // Fabrics' ids
          if (values[3] != null) {
            values[3] = values[3].map((e) => e.id).join(';');
          } // done
          if (values[6] == false) {
            values[6] = 'false';
          } else {
            values[6] = 'true';
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
        values = settings.toMap().values.toList();
        if (values[2] == null) {
          values[2] = '';
        }
        thisTable.appendRow(headerRow);
        thisTable.appendRow(values);
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
    // for (var table in excel.tables.keys) {
    //   for (var row in excel.tables[table].rows) {
    //     print(row);
    //   }
    // }

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
      info: 'Экспорт завершен',
      icon: Icons.done_all_outlined,
    );
    Navigator.pop(context);
  }

  static importFromExcel(BuildContext context) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Excel excel;
      try {
        String file = result.files.single.path;
        Iterable<int> bytes = File(file).readAsBytesSync();
        excel = Excel.decodeBytes(bytes);
      } catch (error) {
        showInfoSnackBar(
          context: context,
          info: 'Ошибка',
          icon: Icons.warning_amber_outlined,
        );
      }
      List<Client> clients = <Client>[];
      List<Order> orders = <Order>[];
      List<Fabric> fabrics = <Fabric>[];
      Settings settings = Settings();

      List<String> headerRow;

      for (var table in excel.tables.keys) {
        var thisTable = excel.tables[table];
        List<dynamic> values;
        if (table == ConstDBData.clientTableName) {
          if (thisTable.rows.length > 0) {
            headerRow =
                thisTable.rows[0].map<String>((e) => e.toString()).toList();
          }
          for (int i = 1; i < thisTable.rows.length; i++) {
            values =
                thisTable.rows[i].map<dynamic>((e) => e.toString()).toList();
            if (values[0].isEmpty) {
              continue;
            } else {
              try {
                values[0] = int.parse(values[0]);
              } catch (error) {
                continue;
              }
            }
            if (values[1].isEmpty) {
              values[1] = null;
            }
            if (values[2].isEmpty) {
              values[2] = 'Пусто';
            }
            if (values[5].isEmpty) {
              values[5] = 'Пусто';
            }
            if (values[9].isEmpty) {
              values[9] = <String>[];
            } else {
              values[9] = values[9].split(';');
            }
            Map<String, dynamic> map =
                Map<String, dynamic>.fromIterables(headerRow, values);
            clients.add(Client.fromMap(map));
          }
        } else if (table == ConstDBData.fabricTableName) {
          if (thisTable.rows.length > 0) {
            headerRow =
                thisTable.rows[0].map<String>((e) => e.toString()).toList();
          }
          for (int i = 1; i < thisTable.rows.length; i++) {
            values =
                thisTable.rows[i].map<dynamic>((e) => e.toString()).toList();
            if (values[0].isEmpty) {
              continue;
            } else {
              try {
                values[0] = int.parse(values[0]);
              } catch (error) {
                continue;
              }
            }
            if (values[1].isEmpty) {
              values[1] = 'Пусто';
            }
            if (values[2].isEmpty) {
              values[2] = 0.0;
            } else {
              try {
                values[2] = double.parse(values[2]);
              } catch (error) {
                continue;
              }
            }
            if (values[3].isEmpty) {
              values[3] = 0.0;
            } else {
              try {
                values[3] = double.parse(values[3]);
              } catch (error) {
                continue;
              }
            }
            Map<String, dynamic> map =
                Map<String, dynamic>.fromIterables(headerRow, values);
            fabrics.add(Fabric.fromMap(map));
          }
        } else if (table == ConstDBData.orderTableName) {
          if (thisTable.rows.length > 0) {
            headerRow =
                thisTable.rows[0].map<String>((e) => e.toString()).toList();
          }
          for (int i = 1; i < thisTable.rows.length; i++) {
            values =
                thisTable.rows[i].map<dynamic>((e) => e.toString()).toList();
            if (values[0].isEmpty) {
              continue;
            } else {
              try {
                values[0] = int.parse(values[0]);
              } catch (error) {
                continue;
              }
            }
            if (values[1].isEmpty) {
              continue;
            } else {
              try {
                values[1] = int.parse(values[1]);
                values[1] = Client(id: values[1]);
              } catch (error) {
                continue;
              }
            }
            if (values[2].isEmpty) {
              values[2] = 0.0;
            } else {
              try {
                values[2] = double.parse(values[2]);
              } catch (error) {
                continue;
              }
            }
            if (values[3].isEmpty) {
              values[3] = <Fabric>[];
            } else {
              values[3] = values[3].split(';');
              List<Fabric> tmp = <Fabric>[];
              for (int j = 0; j < values[3].length; j++) {
                try {
                  tmp.add(Fabric(id: int.parse(values[3][j])));
                } catch (error) {
                  values[3] = <Fabric>[];
                  break;
                }
                if (j == values[3].length - 1) {
                  values[3] = tmp;
                }
              }
            }
            if (values[4].isEmpty) {
              values[4] = 0.0;
            } else {
              try {
                values[4] = double.parse(values[4]);
              } catch (error) {
                continue;
              }
            }
            if (values[5].isEmpty) {
              continue;
            }
            if (values[6].isEmpty) {
              continue;
            } else if (values[6] == 'true') {
              values[6] = true;
            } else if (values[6] == 'false') {
              values[6] = false;
            } else {
              continue;
            }
            Map<String, dynamic> map =
                Map<String, dynamic>.fromIterables(headerRow, values);
            orders.add(Order.fromMap(map));
          }
        } else if (table == ConstDBData.settingsTableName) {
          if (thisTable.rows.length > 0) {
            headerRow =
                thisTable.rows[0].map<String>((e) => e.toString()).toList();
          }
          for (int i = 1; i < thisTable.rows.length; i++) {
            values =
                thisTable.rows[i].map<dynamic>((e) => e.toString()).toList();
            if (values[0].isEmpty) {
              continue;
            } else {
              try {
                values[0] = int.parse(values[0]);
              } catch (error) {
                continue;
              }
            }
            if (values[1].isEmpty) {
              values[1] = ConstData.appTitle;
            }
            if (values[2].isEmpty) {
              values[2] = null;
            }
            Map<String, dynamic> map =
                Map<String, dynamic>.fromIterables(headerRow, values);
            settings = Settings.fromMap(map);
          }
        }
      }
      // for (var c in clients) {
      //   print(c.toMap());
      // }
      // for (var f in fabrics) {
      //   print(f.toMap());
      // }
      // for (var o in orders) {
      //   print(o.toMap());
      // }
      // print(settings.toMap());
      Bloc.bloc.settingsBloc.importExcel(clients, fabrics, orders, settings);
      showInfoSnackBar(
        context: context,
        info: 'Импорт завершен',
        icon: Icons.done_all_outlined,
      );
    }
  }
}
