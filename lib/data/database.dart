import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:quran_flutter/models/verse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  static final verseTable = 'quran_verses';
  static final tajweedTable = 'tajweeds';
  static final _databaseName = 'quranFlutter.db';
  static final _databaseVersion = 1;

  static final setLimit = 200;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDb();
    return _database;
  }

  _initDb() async {
    // Construct the path to the app's writable database file:
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, _databaseName);

    SharedPreferences pref = await SharedPreferences.getInstance();
    bool firstTime = pref.getBool('first_time');

    if (firstTime == null || true) {
      // Delete any existing database:
      await deleteDatabase(dbPath);

      // Create the writable database file from the bundled demo database file:
      ByteData data = await rootBundle.load("assets/quran_db.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
      pref.setBool('first_time', false);
    }

    return await openDatabase(dbPath, version: _databaseVersion);
  }

  Future<List<Verse>> getAllVerse() async {
    var db = await instance.database;
    var queryResults = await db.query(verseTable);
    return queryResults.map((e) => Verse.fromMap(e)).toList();
  }

  Future<List<Verse>> getVerseBySura(int suraID) async {
    var db = await instance.database;
    var queryResults = await db.query(verseTable,
        where: 'suraID = ?', whereArgs: [suraID], orderBy: 'verseID ASC');
    return queryResults.map((e) => Verse.fromMap(e)).toList();
  }

  Future<List<Verse>> getVersesStartFrom(int suraID, int verseID) async {
    var a = suraID;
    var db = await instance.database;
    var queryResults = await db.query(verseTable,
        where: 'suraID = ?',
        whereArgs: [suraID],
        orderBy: 'verseID ASC',
        offset: verseID - 1,
        limit: setLimit);
    var result = queryResults.map((e) => Verse.fromMap(e)).toList();
    while (result.length < setLimit && a <= 114) {
      var queryResults2 = await db.query(verseTable,
          where: 'suraID = ?',
          whereArgs: [++a],
          orderBy: 'verseID ASC',
          limit: setLimit - result.length);
      var tempResult = queryResults2.map((e) => Verse.fromMap(e)).toList();

      result += [
        Verse(
          suraID: tempResult.first.suraID,
          verseID: 0,
          suraName: tempResult.first.suraName,
          body: '',
        )
      ];
      result += tempResult;
    }
    return result;
  }
}
