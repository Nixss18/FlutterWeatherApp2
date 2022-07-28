import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_app/favorites/favorite_provide.dart';

class DBProvider {
  DBProvider._privateConstructor();
  static final DBProvider instance = DBProvider._privateConstructor();

  static Database? _db;
  static const _databaseName = "flutterDB.db";

  Future<Database?> get database async {
    if (_db != null) return _db;
    _db = await _initDB();
    return _db;
  }

  _initDB() async {
    // Directory docDirectory = await getDatabasesPath();
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void>? _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE favoriteCities (id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, lon DOUBLE)');
  }

  Future insert(FavoriteCity favoriteCity) async {
    final Database? database = await instance.database;
    return database?.insert("favoriteCities", favoriteCity.toMap());
  }

  Future<List<FavoriteCity>?> queryAllRows() async {
    Database? db = await instance.database;
    List<Map<String, Object?>>? favoriteCities =
        await db?.query("favoriteCities");

    List<FavoriteCity>? cities =
        favoriteCities?.map((e) => FavoriteCity.fromMap(e)).toList();
    return cities;
  }

  Future<int?> delete(String? name) async {
    Database? db = await instance.database;
    return await db?.delete("favoriteCities");
  }
}
