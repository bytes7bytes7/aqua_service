import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/client.dart';

class ClientDatabase {
  ClientDatabase._privateConstructor();
  static final ClientDatabase db = ClientDatabase._privateConstructor();
  static final _databaseName = "clients.db";
  static final _databaseVersion =
  1; // Increment this version when you need to change the schema.

  static const String _clientTableName = 'clients';
  static const String _imageTableName ='images';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _surname = 'surname';
  static const String _middleName = 'middleName';
  static const String _city = 'city';
  static const String _address = 'address';
  static const String _phone = 'phone';
  static const String _volume = 'volume';
  static const String _previousDate = 'previousDate';
  static const String _nextDate = 'nextDate';
  static const String _clientImages = 'images'; // DO NOT USE AS COLUMN FOR CLIENTS TABLE

  static const String _imageUrl = 'imageUrl';
  static const String _clientId = 'clientId';

  static Database _clientDatabase;
  Future<Database> get clientDatabase async {
    if (_clientDatabase != null) return _clientDatabase;
    _clientDatabase = await _initDB();
    return _clientDatabase;
  }

  Future<Database> _initDB() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    print('init $_databaseName');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print('_onCreate');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_clientTableName (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
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
  }

  Future dropBD()async{
    final db = await clientDatabase;
    await db.execute('DROP TABLE IF EXISTS $_clientTableName;');
    await db.execute('DROP TABLE IF EXISTS $_imageTableName;');
    _onCreate(db, _databaseVersion);
  }

  Future<int> getId(Database db, String tableName)async{
    var table = await db.rawQuery("SELECT MAX($_id)+1 AS $_id FROM $tableName");
    return table.first["$_id"] ?? 1;
  }

  Future addClient(Client client) async {
    print('add');
    final db = await clientDatabase;
    client.id = await getId(db, _clientTableName);
    await db.rawInsert(
        "INSERT INTO $_clientTableName ($_name, $_surname, $_middleName, $_city, $_address, $_phone, $_volume, $_previousDate, $_nextDate) VALUES (?,?,?,?,?,?,?,?,?)",
        [client.name, client.surname, client.middleName, client.city, client.address, client.phone, client.volume, client.previousDate, client.nextDate]);
  }

  Future addImage(int clientId, String url) async {
    print('url: $url, clientId: $clientId');
    final db = await clientDatabase;
    await db.execute(
        'INSERT INTO $_imageTableName ($_imageUrl, $_clientId) VALUES (?,?)',
        [url, clientId]);
  }

  Future updateClient(Client client) async {
    print('update');
    final db = await clientDatabase;
    var map = client.toMap();
    map.remove(_clientImages);
    await db.update("$_clientTableName", map,
        where: "$_id = ?", whereArgs: [client.id]);
  }

  Future<Client> getClient(int id) async {
    final db = await clientDatabase;
    var res =
    await db.query("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await clientDatabase;
    var res = await db.query("$_clientTableName");
    return res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  }

  Future<List<String>> getAllImages(int clientId)async{
    final db = await clientDatabase;
    var res = await db.query("$_imageTableName",where: "$_clientId = ?",whereArgs: [clientId]);
    return res.isNotEmpty ? res.map((e) => e[_imageUrl].toString()).toList(): [];
  }

  Future deleteClient(int id) async {
    print('delete');
    final db = await clientDatabase;
    db.delete("$_clientTableName", where: "$_id = ?", whereArgs: [id]);
  }

  Future deleteAllClients() async {
    final db = await clientDatabase;
    db.rawDelete("DELETE * FROM $_clientTableName");
  }
}
