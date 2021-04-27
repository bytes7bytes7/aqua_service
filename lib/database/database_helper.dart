import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/client.dart';
import '../model/fabric.dart';
import '../model/order.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();
  static final _databaseName = "data.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Names of tables
  static const String _clientTableName = 'clients';
  static const String _orderTableName = 'orders';
  static const String _fabricTableName = 'fabrics';

  // Special columns for clients
  static const String _id = 'id';
  static const String _avatar = 'avatar';
  static const String _name = 'name';
  static const String _surname = 'surname';
  static const String _middleName = 'middleName';
  static const String _city = 'city';
  static const String _address = 'address';
  static const String _phone = 'phone';
  static const String _volume = 'volume';
  static const String _previousDate = 'previousDate';
  static const String _nextDate = 'nextDate';
  static const String _images = 'images';

  // Special columns for fabrics
  static const String _title = 'title';
  static const String _retailPrice = 'retailPrice';
  static const String _purchasePrice = 'purchasePrice';

  static const String _clientId = 'clientId';
  static const String _price = 'price';
  static const String _fabricIds = 'fabricIds';
  static const String _expenses = 'expenses';
  static const String _date = 'date';
  static const String _done = 'done';
  static const String _comment = 'comment';

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_clientTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_avatar TEXT,
        $_name TEXT,
        $_surname TEXT,
        $_middleName TEXT,
        $_city TEXT,
        $_address TEXT,
        $_phone TEXT,
        $_volume TEXT,
        $_previousDate TEXT,
        $_nextDate TEXT,
        $_images TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  $_orderTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_clientId INTEGER,
        $_price REAL,
        $_fabricIds TEXT,
        $_expenses REAL,
        $_date TEXT,
        $_done BOOLEAN,
        $_comment TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  $_fabricTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_title TEXT,
        $_retailPrice REAL,
        $_purchasePrice REAL
      )
    ''');
  }

  Future dropBD() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $_clientTableName;');
    await db.execute('DROP TABLE IF EXISTS $_orderTableName;');
    await db.execute('DROP TABLE IF EXISTS $_fabricTableName;');
    _createDB(db, _databaseVersion);
  }

  Future<int> _getMaxId(Database db, String tableName) async {
    var table = await db.rawQuery("SELECT MAX($_id)+1 AS $_id FROM $tableName");
    return table.first["$_id"] ?? 1;
  }

  // Client methods
  Future addClient(Client client) async {
    final db = await database;
    client.id = await _getMaxId(db, _clientTableName);
    await db.rawInsert(
      "INSERT INTO $_clientTableName ($_avatar, $_name, $_surname, $_middleName, $_city, $_address, $_phone, $_volume, $_previousDate, $_nextDate, $_images) VALUES (?,?,?,?,?,?,?,?,?,?,?)",
      [
        client.avatar,
        client.name,
        client.surname,
        client.middleName,
        client.city,
        client.address,
        client.phone,
        client.volume,
        client.previousDate,
        client.nextDate,
        client.images?.join(';'),
      ],
    );
  }

  Future updateClient(Client client) async {
    final db = await database;
    var map = client.toMap();
    map[_images] = map[_images]?.join(';');
    await db.update("$_clientTableName", map,
        where: "$_id = ?", whereArgs: [client.id]);
  }

  Future<Client> getClient(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
    res.first[_images] = List<String>.from(res.first[_images]?.split(';'));
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query("$_clientTableName");
    List<Map<String, dynamic>> result = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> m = Map<String, dynamic>.from(data[i]);
        List<String> a = [];
        m[_images] = (m[_images].length > 0) ? m[_images].split(';') : a;
        result.add(m);
      }
      return result.map((e) => Client.fromMap(e)).toList();
    } else
      return [];
  }

  Future deleteClient(int id) async {
    final db = await database;
    db.delete("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
  }

  Future deleteAllClients() async {
    final db = await database;
    db.rawDelete("DELETE * FROM $_clientTableName");
  }

  // Fabric methods
  Future addFabric(Fabric fabric) async {
    final db = await database;
    fabric.id = await _getMaxId(db, _fabricTableName);
    await db.rawInsert(
        "INSERT INTO $_fabricTableName ($_id,$_title,$_retailPrice,$_purchasePrice) VALUES (?,?,?,?)",
        [
          fabric.id,
          fabric.title,
          fabric.retailPrice,
          fabric.purchasePrice,
        ]);
  }

  Future updateFabric(Fabric fabric) async {
    final db = await database;
    var map = fabric.toMap();
    await db.update("$_fabricTableName", map,
        where: "$_id = ?", whereArgs: [fabric.id]);
  }

  Future<Fabric> getFabric(int id) async {
    final db = await database;
    List<Map<String, dynamic>>  res =
        await db.query("$_fabricTableName", where: "$_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Fabric.fromMap(res.first) : null;
  }

  Future<List<Fabric>> getAllFabrics() async {
    final db = await database;
    List<Map<String, dynamic>>  res = await db.query("$_fabricTableName");
    return res.isNotEmpty ? res.map((c) => Fabric.fromMap(c)).toList() : [];
  }

  Future deleteFabric(int id) async {
    final db = await database;
    db.delete("$_fabricTableName", where: "$_id = ?", whereArgs: [id]);
  }

  Future deleteAllFabrics() async {
    final db = await database;
    db.rawDelete("DELETE * FROM $_fabricTableName");
  }


  // Order methods
  Future addOrder(Order order) async {
    final db = await database;
    order.id = await _getMaxId(db, _orderTableName);
    await db.rawInsert(
      "INSERT INTO $_orderTableName ($_id, $_clientId, $_price, $_fabricIds, $_expenses, $_date, $_done, $_comment) VALUES (?,?,?,?,?,?,?,?)",
      [
        order.id,
        order.clientId,
        order.price,
        order.fabricIds.join(';'),
        order.expenses,
        order.date,
        order.done,
        order.comment,
      ],
    );
  }

  Future updateOrder(Order order) async {
    final db = await database;
    var map = order.toMap();
    map[_fabricIds] = map[_fabricIds]?.join(';');
    await db.update("$_orderTableName", map,
        where: "$_id = ?", whereArgs: [order.id]);
  }

  Future<Order> getOrder(int id) async {
    final db = await database;
    List<Map<String, dynamic>>  res =
        await db.query("$_orderTableName", where: "$_id = ?", whereArgs: [id]);
    res.first[_fabricIds] = List<int>.from(res.first[_fabricIds]?.split(';'));
    return res.isNotEmpty ? Order.fromMap(res.first) : null;
  }

  Future<List<Order>> getAllOrders() async {
    final db = await database;
    List<Map<String, dynamic>> data = await db.query("$_orderTableName");
    List<Map<String, dynamic>> result = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> m = Map<String, dynamic>.from(data[i]);
        List<String> a = [];
        m[_fabricIds] = (m[_fabricIds].length > 0) ? m[_fabricIds].split(';') : a;
        result.add(m);
      }
      return result.map((e) => Order.fromMap(e)).toList();
    } else
      return [];
  }

  Future deleteOrder(int id) async {
    final db = await database;
    db.delete("$_orderTableName", where: "$_id = ?", whereArgs: [id]);
  }

  Future deleteAllOrders() async {
    final db = await database;
    db.rawDelete("DELETE * FROM $_orderTableName");
  }
}
