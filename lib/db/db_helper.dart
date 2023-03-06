import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

//  creat db
  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null database');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        debugPrint('in database');
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint('create one database');
          return await db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, note TEXT, date STRING, '
            'startTime STRING, endTime TEXT, '
            'remind INTEGER, repeat STRING, '
            'color INTEGER, '
            'isCompleted INTEGER)',
          );
        });
        debugPrint('created database');
      } catch (e) {
        print(e);
      }
    }
  }

  //insert data in db
  static Future<int> insert(Task? task) async {
    print('insert');
    return await _db!.insert(_tableName, task!.toJson());
  }

  ////////////////////

  //delete data in db
  static Future<int> delete(Task? task) async {
    print('deleted');
    return await _db!
        .delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }
  ////////////////////

  //delete All data in db
  static Future<int> deleteAll() async {
    print('deleted');
    return await _db!.delete(_tableName);
  }
  ////////////////////

  //screach data in db
  static Future<List<Map<String, dynamic>>> query() async {
    print('query');
    return await _db!.query(_tableName);
  }

  ////////////////////

  //update data in db
  static Future<int> update(int id) async {
    print('updated');
    return await _db!.rawUpdate(
      '''
      UPDATE tasks
      SET isCompleted = ?
      WHERE ID = ?
      ''',
      [
        1,
        id,
      ],
    );
  }

  ////////////////////

}
