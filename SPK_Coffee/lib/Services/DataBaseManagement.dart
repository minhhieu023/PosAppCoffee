import 'package:SPK_Coffee/Models/Order.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseManagement {
  Database database;
  Future<void> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'demo.db';
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Products (id INTEGER PRIMARY KEY, productName TEXT, productDescription TEXT, price TEXT,hot text,popular text,processDuration text, mainImage text, categoryId INTEGER)');
      await db.execute(
          'create table IF NOT EXISTS Categories (id INTEGER PRIMARY KEY, name text)');
      await db.execute(
          'create table IF NOT EXISTS Areas (Id INTEGER PRIMARY KEY, name text,waiter1 text, waiter2 text, amountOfTable INTEGER )');
      await db.execute(
          'create table IF NOT EXISTS Tables (Id INTEGER PRIMARY KEY, name text,isEmpty text, AreaId INTEGER )');
      await db.execute(
          'create table IF NOT EXISTS Orders (id INTEGER PRIMARY KEY,employeeId text, date text, state text, total text, discount text, voucherId text, note text )');
      await db.execute(
          'create table IF NOT EXISTS OrderDetails (id INTEGER PRIMARY KEY,productId integer, amount integer,price text, orderId integer )');
    });
  }

  Future<void> dropTableIfExists(String table) async {
    await database.rawQuery("DELETE FROM $table");
  }

  Future<void> deleteRecord(String table, String whereClause) async {
    await database.delete("delete from $table  where $whereClause ");
  }

  Future<void> insertDB(String table, String keys, List<String> values) async {
    String record = values.map((e) => "?").toString();
    if (database.isOpen) {
      await database.transaction((txn) async {
        var result = await txn.rawInsert(
            'INSERT INTO $table $keys VALUES $record', values);
        print(result);
      });
    }
  }

  Future<void> getTable(String table) async {
    if (database.isOpen) {
      var result = await database.rawQuery("select * from $table");
      print(result);
    }
  }

  Future<int> updateRecord(
      String table, String setClause, String whereClause) async {
    return await database
        .rawUpdate('update $table set $setClause Where $whereClause');
  }

  void saveOrderTables(Order order) async {
    if (database.isOpen) {
      await database.transaction((txn) async {
        await txn.rawQuery("DELETE FROM Orders");
        await txn.rawQuery("DELETE FROM OrderDetails");
        await txn.rawInsert(
            'Insert into Orders(id,employeeId,date,state,total,discount,voucherId,note) Values (?,?,?,?,?,?,?,?)',
            [
              order.id,
              order.employeeId ?? 'null',
              order.date,
              order.state,
              order.total,
              order.discount ?? 'null',
              order.voucherId,
              order.note
            ]);
        order.details.forEach((item) async {
          await txn.rawInsert(
              'Insert into OrderDetails(id,productId, amount,price, orderId ) values (?,?,?,?,?)',
              [item.id, item.productId, item.amount, item.price, item.orderId]);
        });
      });
    }
  }

  Future<List<Order>> getOrderList() async {
    var orderList;
    List<Order> list = [];
    await database.transaction((txn) async {
      orderList =
          await txn.rawQuery("select * from Orders where state !='closed'");
      print(orderList);
    });
  }

  Future<void> closeDB() async {
    await database.close();
  }
}
