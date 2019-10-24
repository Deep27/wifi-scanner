import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wifi_scanner/model/user.dart';

class DatabaseHelper {
  static final _databaseName = 'database.db';
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${User.tableName} (
        ${User.columnId} INTEGER PRIMARY KEY,
        ${User.columnLogin} VARCHAR NOT NULL,
        ${User.columnBranch} VARCHAR NOT NULL,
        ${User.columnGosb} VARCHAR NOT NULL,
        ${User.columnDeviceSerialId} VARCHAR NOT NULL
      )
    ''');
  }

  Future<User> insertUser(User user) async {
    assert (user.id == null);
    Database db = await database;
    int newId = await db.insert(User.tableName, user.toMap());
    user.id = newId;
    return user;
  }

  Future<User> selectUser(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(User.tableName,
        columns: [
          User.columnId,
          User.columnLogin,
          User.columnBranch,
          User.columnGosb,
          User.columnDeviceSerialId
        ],
        where: '${User.columnId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  } 
}
