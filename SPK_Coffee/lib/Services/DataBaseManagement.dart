import 'package:sqflite/sqflite.dart';

class DataBaseManagement {
  Database database;
  void initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'demo.db';
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Products (id INTEGER PRIMARY KEY, productName TEXT, productDescription TEXT, price TEXT,hot text,popular text,processDuration text, mainImage text, categoryId int)');
      await db.execute('create table Categories (id integer, name text)');
      await db.execute(
          'create table Areas (Id integer, name text,waiter1 text, waiter2 text, amountOfTable int )');
      await db.execute(
          'create table Tables (Id int, name text,isEmpty text, AreaId int ');
    });
  }

  void insertDB(String table, List<String> keys, List<String> values) async {
    String keyColumn = keys.map((e) => "$e ,").toString();
    String record = values.map((e) => "$e ,").toString();
    print(keyColumn);
    if (database.isOpen) {
      await database.transaction((txn) async {
        var result = await txn
            .rawInsert('INSERT INTO $table ($keyColumn) VALUES($record)');
        print(result);
      });
    }
  }

  void closeDB() {
    database.close();
  }
}
