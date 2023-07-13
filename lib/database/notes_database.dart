import 'package:anunoteapp/models/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Future<Database> connectDb() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), 'noteapp.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE tableNote(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
        );
      },
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
    return database;
  }

  create(NotesModel notesModel) async {
    final db = await DatabaseService().connectDb();
    await db.insert(
      "tableNote",
      notesModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NotesModel>> readNote() async {
    final db = await DatabaseService().connectDb();
    var dbRead = await db.query('tableNote');
    return List.generate(
      dbRead.length,
      (index) {
        return NotesModel(
          title: dbRead[index]['title'] as String,
          description: dbRead[index]['description'] as String,
          id: dbRead[index]['id'] as int,
        );
      },
    );
  }

  delete(int id) async {
    final db = await DatabaseService().connectDb();
    await db.delete(
      'tableNote',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  update(NotesModel notesModel) async {
    final db = await connectDb();
    await db.update(
      'tableNote',
      notesModel.toMap(),
      where: 'id = ?',
      whereArgs: [notesModel.id],
    );
  }

}
