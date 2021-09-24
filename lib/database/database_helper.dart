import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/client.dart';
import '../model/fabric.dart';
import '../model/order.dart';
import '../model/settings.dart';
import '../constants.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, ConstDBData.databaseName);
    return await openDatabase(path,
        version: ConstDBData.databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${ConstDBData.clientTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.avatar} TEXT,
        ${ConstDBData.name} TEXT,
        ${ConstDBData.surname} TEXT,
        ${ConstDBData.middleName} TEXT,
        ${ConstDBData.city} TEXT,
        ${ConstDBData.address} TEXT,
        ${ConstDBData.phone} TEXT,
        ${ConstDBData.volume} REAL,
        ${ConstDBData.images} TEXT,
        ${ConstDBData.comment} TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  ${ConstDBData.orderTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.client} INTEGER,
        ${ConstDBData.price} REAL,
        ${ConstDBData.fabrics} TEXT,
        ${ConstDBData.expenses} REAL,
        ${ConstDBData.date} TEXT,
        ${ConstDBData.done} BOOLEAN,
        ${ConstDBData.comment} TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  ${ConstDBData.fabricTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.title} TEXT,
        ${ConstDBData.retailPrice} REAL,
        ${ConstDBData.purchasePrice} REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  ${ConstDBData.settingsTableName} (
        ${ConstDBData.id} INTEGER PRIMARY KEY,
        ${ConstDBData.appTitle} TEXT,
        ${ConstDBData.icon} TEXT
      )
    ''');
  }

  Future dropDB(String dbName) async {
    final db = await database;
    switch (dbName) {
      case ConstDBData.clientTableName:
        await db
            .execute('DROP TABLE IF EXISTS ${ConstDBData.clientTableName};');
        break;
      case ConstDBData.orderTableName:
        await db.execute('DROP TABLE IF EXISTS ${ConstDBData.orderTableName};');
        break;
      case ConstDBData.fabricTableName:
        await db
            .execute('DROP TABLE IF EXISTS ${ConstDBData.fabricTableName};');
        break;
      case ConstDBData.settingsTableName:
        throw Exception('Deletion of settingsTable can cause error');
      default:
        await db
            .execute('DROP TABLE IF EXISTS ${ConstDBData.clientTableName};');
        await db.execute('DROP TABLE IF EXISTS ${ConstDBData.orderTableName};');
        await db
            .execute('DROP TABLE IF EXISTS ${ConstDBData.fabricTableName};');
        await _createDB(db, ConstDBData.databaseVersion);
    }
  }

  Future<int> _getMaxId(Database db, String tableName) async {
    var table = await db.rawQuery(
        "SELECT MAX(${ConstDBData.id})+1 AS ${ConstDBData.id} FROM $tableName");
    dynamic result = table.first["${ConstDBData.id}"];
    if (result != null){
      result = result as int;
    }else{
      result = 1;
    }
    return result;
  }

  // Client methods
  Future addClient(Client client) async {
    final db = await database;
    client.id = await _getMaxId(db, ConstDBData.clientTableName);
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.clientTableName} (${ConstDBData.id}, ${ConstDBData.avatar}, ${ConstDBData.name}, ${ConstDBData.surname}, ${ConstDBData.middleName}, ${ConstDBData.city}, ${ConstDBData.address}, ${ConstDBData.phone}, ${ConstDBData.volume}, ${ConstDBData.images}, ${ConstDBData.comment}) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
      [
        client.id,
        client.avatar,
        client.name,
        client.surname,
        client.middleName,
        client.city,
        client.address,
        client.phone,
        client.volume,
        client.images?.join(';'),
        client.comment,
      ],
    );
  }

  Future addAllClients(List<Client> clients) async {
    final db = await database;
    int id = await _getMaxId(db, ConstDBData.clientTableName);
    for (Client client in clients) {
      client.id = id;
      await db.rawInsert(
        "INSERT INTO ${ConstDBData.clientTableName} (${ConstDBData.id}, ${ConstDBData.avatar}, ${ConstDBData.name}, ${ConstDBData.surname}, ${ConstDBData.middleName}, ${ConstDBData.city}, ${ConstDBData.address}, ${ConstDBData.phone}, ${ConstDBData.volume}, ${ConstDBData.images}, ${ConstDBData.comment}) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          client.id,
          client.avatar,
          client.name,
          client.surname,
          client.middleName,
          client.city,
          client.address,
          client.phone,
          client.volume,
          client.images?.join(';'),
          client.comment,
        ],
      );
      id++;
    }
  }

  Future updateClient(Client client) async {
    final db = await database;
    var map = client.toMap();
    map[ConstDBData.images] = map[ConstDBData.images]?.join(';');
    await db.update("${ConstDBData.clientTableName}", map,
        where: "${ConstDBData.id} = ?", whereArgs: [client.id]);
  }

  Future<Client> getClient(int id) async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query(
        "${ConstDBData.clientTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [id]);
    if (data.isNotEmpty) {
      Map<String, dynamic> m = Map<String, dynamic>.from(data.first);
      List<String> a = [];
      m[ConstDBData.images] = (m[ConstDBData.images].length > 0)
          ? m[ConstDBData.images].split(';')
          : a;
      return Client.fromMap(m);
    } else
      return Client();
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    List<Map<String, dynamic>> data =
        await db.query("${ConstDBData.clientTableName}");
    List<Map<String, dynamic>> result = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> m = Map<String, dynamic>.from(data[i]);
        List<String> a = [];
        m[ConstDBData.images] = (m[ConstDBData.images].length > 0)
            ? m[ConstDBData.images].split(';')
            : a;
        result.add(m);
      }
      return result.map((e) => Client.fromMap(e)).toList();
    } else
      return [];
  }

  Future deleteClient(int id) async {
    final db = await database;
    db.delete("${ConstDBData.clientTableName}",
        where: "${ConstDBData.id} = ?", whereArgs: [id]);
  }

  Future deleteAllClients() async {
    final db = await database;
    // this code does not delete a row
    db.rawDelete("DELETE FROM ${ConstDBData.clientTableName}");
  }

  // Fabric methods
  Future addFabric(Fabric fabric) async {
    final db = await database;
    fabric.id = await _getMaxId(db, ConstDBData.fabricTableName);
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.fabricTableName} (${ConstDBData.id}, ${ConstDBData.title},${ConstDBData.retailPrice},${ConstDBData.purchasePrice}) VALUES (?,?,?,?)",
      [
        fabric.id,
        fabric.title,
        fabric.retailPrice,
        fabric.purchasePrice,
      ],
    );
  }

  Future addAllFabrics(List<Fabric> fabrics) async {
    final db = await database;
    int id = await _getMaxId(db, ConstDBData.fabrics);
    for (Fabric fabric in fabrics) {
      fabric.id = id;
      await db.rawInsert(
        "INSERT INTO ${ConstDBData.fabricTableName} (${ConstDBData.id}, ${ConstDBData.title},${ConstDBData.retailPrice},${ConstDBData.purchasePrice}) VALUES (?,?,?,?)",
        [
          fabric.id,
          fabric.title,
          fabric.retailPrice,
          fabric.purchasePrice,
        ],
      );
      id++;
    }
  }

  Future updateFabric(Fabric fabric) async {
    final db = await database;
    var map = fabric.toMap();
    await db.update("${ConstDBData.fabricTableName}", map,
        where: "${ConstDBData.id} = ?", whereArgs: [fabric.id]);
  }

  Future<Fabric> getFabric(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
        "${ConstDBData.fabricTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [id]);
    return res.isNotEmpty ? Fabric.fromMap(res.first) : Fabric();
  }

  Future<List<Fabric>> getAllFabrics() async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query("${ConstDBData.fabricTableName}");
    return res.isNotEmpty ? res.map((c) => Fabric.fromMap(c)).toList() : [];
  }

  Future deleteFabric(int id) async {
    final db = await database;
    db.delete("${ConstDBData.fabricTableName}",
        where: "${ConstDBData.id} = ?", whereArgs: [id]);
  }

  Future deleteAllFabrics() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${ConstDBData.fabricTableName}");
  }

  // Order methods
  Future addOrder(Order order) async {
    final db = await database;
    order.id = await _getMaxId(db, ConstDBData.orderTableName);
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.orderTableName} (${ConstDBData.id}, ${ConstDBData.client}, ${ConstDBData.price}, ${ConstDBData.fabrics}, ${ConstDBData.expenses}, ${ConstDBData.date}, ${ConstDBData.done}, ${ConstDBData.comment}) VALUES (?,?,?,?,?,?,?,?)",
      [
        order.id,
        order.client!.id,
        order.price,
        order.fabrics!.map((e) => e.id).join(';'),
        order.expenses,
        order.date,
        order.done,
        order.comment,
      ],
    );
  }

  Future addAllOrders(List<Order> orders) async {
    final db = await database;
    int id = await _getMaxId(db, ConstDBData.orderTableName);
    for (Order order in orders) {
      order.id = id;
      await db.rawInsert(
        "INSERT INTO ${ConstDBData.orderTableName} (${ConstDBData.id}, ${ConstDBData.client}, ${ConstDBData.price}, ${ConstDBData.fabrics}, ${ConstDBData.expenses}, ${ConstDBData.date}, ${ConstDBData.done}, ${ConstDBData.comment}) VALUES (?,?,?,?,?,?,?,?)",
        [
          order.id,
          order.client!.id,
          order.price,
          order.fabrics!.map((e) => e.id).join(';'),
          order.expenses,
          order.date,
          order.done,
          order.comment,
        ],
      );
      id++;
    }
  }

  Future updateOrder(Order order) async {
    final db = await database;
    var map = order.toMap();
    map[ConstDBData.client] = map[ConstDBData.client].id;
    map[ConstDBData.fabrics] =
        map[ConstDBData.fabrics].map((e) => e.id)?.join(';');
    await db.update("${ConstDBData.orderTableName}", map,
        where: "${ConstDBData.id} = ?", whereArgs: [order.id]);
  }

  Future<Order?> getOrder(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
        "${ConstDBData.orderTableName}",
        where: "${ConstDBData.id} = ?",
        whereArgs: [id]);
    res.first[ConstDBData.client] = getClient(res.first[ConstDBData.client]);
    res.first[ConstDBData.fabrics] =
        List<int>.from(res.first[ConstDBData.fabrics]?.split(';'))
            .map((id) => getFabric(id));
    return res.isNotEmpty ? Order.fromMap(res.first) : null;
  }

  Future<List<Order>> getAllOrders() async {
    final db = await database;
    List<Map<String, dynamic>> data =
        await db.query("${ConstDBData.orderTableName}");
    List<Map<String, dynamic>> result = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> m = Map<String, dynamic>.from(data[i]);
        m[ConstDBData.client] = await getClient(m[ConstDBData.client]);
        if (m[ConstDBData.client].id == null) {
          await deleteOrder(m[ConstDBData.id]);
          continue;
        }
        if (m[ConstDBData.fabrics].length > 0) {
          List<String> ids = m[ConstDBData.fabrics].split(';');
          m[ConstDBData.fabrics] = List<Fabric>.from([]).toList();
          for (int j = 0; j < ids.length; j++) {
            Fabric f = await getFabric(int.parse(ids[j]));
            if (f.id == null) {
              await deleteFabric(int.parse(ids[j]));
            } else {
              await m[ConstDBData.fabrics].add(f);
            }
          }
        } else
          m[ConstDBData.fabrics] = List<Fabric>.from([]).toList();

        result.add(m);
      }
      return result.map<Order>((e) => Order.fromMap(e)).toList();
    } else
      return [];
  }

  Future deleteOrder(int id) async {
    final db = await database;
    db.delete("${ConstDBData.orderTableName}",
        where: "${ConstDBData.id} = ?", whereArgs: [id]);
  }

  Future deleteAllOrders() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${ConstDBData.orderTableName}");
  }

  // Settings methods
  Future addSettings(Settings settings) async {
    final db = await database;
    await db.rawInsert(
      "INSERT INTO ${ConstDBData.settingsTableName} (${ConstDBData.id}, ${ConstDBData.appTitle}, ${ConstDBData.icon}) VALUES (?,?,?)",
      [
        1,
        settings.appTitle,
        settings.icon,
      ],
    );
  }

  Future updateSettings(Settings settings) async {
    final db = await database;
    var map = settings.toMap();
    try {
      await db.update("${ConstDBData.settingsTableName}", map,
          where: "${ConstDBData.id} = ?", whereArgs: [settings.id]);
    } catch (error) {
      await addSettings(Settings(
        id: 1,
        appTitle: map['appTitle'],
        icon: map['icon'],
      ));
    }
  }

  Future<Settings> getSettings() async {
    final db = await database;
    List<Map<String, dynamic>> res;
    try {
      res = await db.query("${ConstDBData.settingsTableName}");
      if (res.length == 0) {
        await addSettings(Settings(
          id: 1,
          appTitle: ConstData.appTitle,
          icon: null,
        ));
        res = await db.query("${ConstDBData.settingsTableName}");
      }
    } catch (error) {
      await _createDB(db, ConstDBData.databaseVersion);
      addSettings(Settings(
        id: 1,
        appTitle: ConstData.appTitle,
        icon: null,
      ));
      res = await db.query("${ConstDBData.settingsTableName}");
    }
    return res.isNotEmpty
        ? Settings.fromMap(res.first)
        : Settings(appTitle: null, icon: null);
  }

  Future deleteSettings() async {
    final db = await database;
    db.delete("${ConstDBData.settingsTableName}",
        where: "${ConstDBData.id} = ?", whereArgs: [1]);
    await addSettings(Settings(
      id: 1,
      appTitle: ConstDBData.appTitle,
      icon: null,
    ));
  }
}
