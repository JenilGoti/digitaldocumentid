// ignore_for_file: unused_field, prefer_const_declarations
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'my_table';
  static final documentId = '_id';
  static final documentName = '_name';
  static final documentPath = '_filepath';
  var result;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      new DatabaseHelper._privateConstructor();

  static Database? _database;

  static Future<Database?> get database async {
    final databasePath = await getDatabasesPath();
    final status = await databaseExists(databasePath);
    if (!status) {
      _database = await openDatabase(join(databasePath, 'MyDatabase1.db'),
          onCreate: (database, version) {
        return database.execute("CREATE TABLE $table("
            "$documentId TEXT PRIMARY KEY, "
            "$documentName TEXT, "
            "$documentPath TEXT)");
      }, version: _databaseVersion);
    }
    return _database;
  }

  Future<bool> insert(Map<String, dynamic> row) async {
    final db = await database;
    try {
      await db!.insert(table, row);
    } on Error {
      throw Error();
    }
    return true;
  }

  
  
  
  Future<List<Map<String, dynamic>>> getAllDoc() async {
    Database? db = await database;
    result = await db!.query(table);
    return result.toList();
  }

  Future <List<Map<String,dynamic>>> getSpecificDoc(String id) async{
    Database? db= await database;
    // return await db!.query(table,where: "age = ?",whereArgs: [age]);
    return await db!.rawQuery(''' SELECT * FROM $table WHERE $documentId = ?  ''',[id]);
  }


  Future<int> updateStatic(
      {Map<String, dynamic>? row, String? id}) async {
    Database? db = await database;
    return await db!
        .update(table, row!, where: '$documentId = ?', whereArgs: [id]);
  }

  Future<int> delete(String id) async {
    Database? db = await database;
    return await db!.delete(table, where: '$documentId = ?', whereArgs: [id]);
  }

  Map<String, dynamic> row(String id, String docName, String docPath) {
    return {
      documentId: id,
      documentName: docName,
      documentPath: docPath,
    };
  }
}
