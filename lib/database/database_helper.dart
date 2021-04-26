import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/client.dart';
import '../model/fabric.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper db = DatabaseHelper._privateConstructor();
  static final _databaseName = "data.db";
  static final _databaseVersion =
      1; // Increment this version when you need to change the schema.

  // Names of tables
  static const String _clientTableName = 'clients';
  static const String _imageTableName = 'images';

  // static const String _orderTableName = 'orders';
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
  static const String _clientImages =
      'images'; // DO NOT USE AS COLUMN FOR CLIENTS TABLE

  // Special columns for images
  static const String _imageUrl = 'imageUrl';
  static const String _clientId = 'clientId';

  // Special columns for fabrics
  static const String _title = 'title';
  static const String _retailPrice = 'retailPrice';
  static const String _purchasePrice = 'purchasePrice';

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
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
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
        $_nextDate TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  $_imageTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_imageUrl TEXT,
        $_clientId INTEGER,
        FOREIGN KEY($_clientId) REFERENCES $_clientTableName($_id)
      )
    ''');
    // await db.execute('''
    //   CREATE TABLE IF NOT EXISTS  $_orderTableName (
    //     $_id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     FOREIGN KEY($_clientId) REFERENCES $_clientTableName($_id)
    //   )
    // ''');
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
    await db.execute('DROP TABLE IF EXISTS $_imageTableName;');
    // await db.execute('DROP TABLE IF EXISTS $_orderTableName;');
    await db.execute('DROP TABLE IF EXISTS $_fabricTableName;');
    _onCreate(db, _databaseVersion);
  }

  Future<int> getMaxId(Database db, String tableName) async {
    var table = await db.rawQuery("SELECT MAX($_id)+1 AS $_id FROM $tableName");
    return table.first["$_id"] ?? 1;
  }

  // Client methods
  Future addClient(Client client) async {
    final db = await database;
    client.id = await getMaxId(db, _clientTableName);
    await db.rawInsert(
      "INSERT INTO $_clientTableName ($_avatar, $_name, $_surname, $_middleName, $_city, $_address, $_phone, $_volume, $_previousDate, $_nextDate) VALUES (?,?,?,?,?,?,?,?,?,?)",
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
      ],
    );
  }

  Future updateClient(Client client) async {
    final db = await database;
    var map = client.toMap();
    var images = await getAllImages(client.id);
    if(map[_clientImages]!=null) {
      for (int i = 0; i < map[_clientImages].length; i++) {
        if (images.contains(map[_clientImages][i]))
          map[_clientImages].removeAt(i);
      }
      for(int i =0;i<map[_clientImages].length;i++)
        await db.rawInsert(
          "INSERT INTO $_imageTableName ($_imageUrl, $_clientId) VALUES (?,?)",
          [
            map[_clientImages][i],
            client.id,
          ],
        );
    }
    map.remove(_clientImages);
    await db.update("$_clientTableName", map,
        where: "$_id = ?", whereArgs: [client.id]);
  }

  Future<Client> getClient(int id) async {
    final db = await database;
    var res =
        await db.query("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("$_clientTableName");
    return res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  }

  Future deleteClient(int id) async {
    final db = await database;
    db.delete("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
  }

  Future deleteAllClients() async {
    final db = await database;
    db.rawDelete("DELETE * FROM $_clientTableName");
  }

  // Image methods
  Future addImage(int clientId, String url) async {
    final db = await database;
    await db.execute(
        'INSERT INTO $_imageTableName ($_imageUrl, $_clientId) VALUES (?,?)',
        [url, clientId]);
  }

  // Future updateImage(){}

  Future<List<String>> getAllImages(int clientId) async {
    final db = await database;
    var res = await db.query("$_imageTableName",
        where: "$_clientId = ?", whereArgs: [clientId]);
    return res.isNotEmpty
        ? res.map((e) => e[_imageUrl].toString()).toList()
        : [];
  }

  // Future deleteImage(){}

  // Future deleteAllImages(){}

  // Fabric methods
  Future addFabric(Fabric fabric) async {
    final db = await database;
    fabric.id = await getMaxId(db, _fabricTableName);
    await db.rawInsert(
        "INSERT INTO $_fabricTableName ($_id,$_title,$_retailPrice,$_purchasePrice)VALUES(?,?,?,?)",
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
    var res =
        await db.query("$_fabricTableName", where: "$_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Fabric.fromMap(res.first) : null;
  }

  Future<List<Fabric>> getAllFabrics() async {
    final db = await database;
    var res = await db.query("$_fabricTableName");
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
}
