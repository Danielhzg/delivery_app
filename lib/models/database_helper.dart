import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'comment.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('comments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute(''' 
      CREATE TABLE comments ( 
        id $idType, 
        userId $textType,
        content $textType,
        rating $intType
      )
    ''');
  }

  Future<void> insertComment(Comment comment) async {
    final db = await instance.database;
    print("Inserting comment: ${comment.toMap()}"); // Tambahkan ini untuk melihat data yang akan dimasukkan
    await db.insert('comments', comment.toMap());
  }

  Future<List<Comment>> fetchComments() async {
    final db = await instance.database;
    final result = await db.query('comments');
    return result.map((json) => Comment.fromMap(json)).toList();
  }

  Future<void> deleteComment(int id) async {
    final db = await instance.database;
    await db.delete('comments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateComment(Comment comment) async {
    final db = await instance.database;
    print("Updating comment: ${comment.toMap()}"); // Tambahkan ini untuk melihat data yang akan diperbarui

    await db.update(
      'comments',
      comment.toMap(),
      where: 'id = ?',
      whereArgs: [comment.id],
    );
  }
}
