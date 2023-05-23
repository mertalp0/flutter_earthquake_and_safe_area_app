
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/directory_model.dart';

int? id;
String? name;
String? phone;

class DatabaseHelper {
  static const _databaseName = "directory.db";
  static const _databaseVersion = 1;
  static const table = 'directory_table';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPhone = 'phone';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    var db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async {
    db.execute('''CREATE TABLE $table (
      '$columnId' INTEGER PRIMARY KEY AUTOINCREMENT , 
      '$columnName' TEXT NOT NULL , 
      '$columnPhone' TEXT NOT NULL
    )  ''');
  }

  Future<int> insert(Directory directory) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'name': directory.name,
      'phone': directory.phone,
    });
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId=?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}
