import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/models.dart';

class DatabaseServices {
  Future<Database> connectDb() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), 'todoapp.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE tableTodos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isChecked INTEGER)',
        );
      },
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
    if (database != null) {
      print('Database connected successfully');
      return database;
    } else {
      print('Database not connected');
      return database;
    }
  }

  create(TodoModel todoModel) async {
    final db = await DatabaseServices().connectDb();
    await db.insert(
      "tableTodos",
      todoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> readNote() async {
    final db = await DatabaseServices().connectDb();
    var dbRead = await db.query(
      'tableTodos',
    );
    return List.generate(
      dbRead.length,
      (index) {
        return TodoModel(
          title: dbRead[index]['title'] as String,
          isChecked: dbRead[index]['isChecked'] == 1 ? true : false,
          id: dbRead[index]['id'] as int,
        );
      },
    );
  }

  Future<List<TodoModel>>delete(int id) async {
    final db = await DatabaseServices().connectDb();
    await db.delete(
      'tableTodos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return readNote();
  }

  Future<List<TodoModel>> update(TodoModel todo) async {
    final db = await DatabaseServices().connectDb();
    await db.update(
      'tableTodos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    return readNote();
  }
}
