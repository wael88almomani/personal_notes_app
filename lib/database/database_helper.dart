import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const String _dbName = 'personal_notes.db';
  static const int _dbVersion = 3;
  static const String _tableName = 'notes';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_date TEXT NOT NULL,
        last_modified TEXT NOT NULL,
        is_pinned INTEGER NOT NULL DEFAULT 0,
        color_code TEXT NOT NULL DEFAULT 'default',
        font_size REAL NOT NULL DEFAULT 16.0,
        font_family TEXT NOT NULL DEFAULT 'default',
        text_color TEXT NOT NULL DEFAULT 'black'
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $_tableName ADD COLUMN last_modified TEXT');
      await db.execute(
        'ALTER TABLE $_tableName ADD COLUMN is_pinned INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE $_tableName ADD COLUMN color_code TEXT NOT NULL DEFAULT "default"',
      );
      // Update existing records with last_modified = created_date
      await db.execute(
        'UPDATE $_tableName SET last_modified = created_date WHERE last_modified IS NULL',
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE $_tableName ADD COLUMN font_size REAL NOT NULL DEFAULT 16.0',
      );
      await db.execute(
        'ALTER TABLE $_tableName ADD COLUMN font_family TEXT NOT NULL DEFAULT "default"',
      );
      await db.execute(
        'ALTER TABLE $_tableName ADD COLUMN text_color TEXT NOT NULL DEFAULT "black"',
      );
    }
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    final map = note.toMap();
    map.remove('id');
    return db.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'is_pinned DESC, last_modified DESC',
    );
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'is_pinned DESC, last_modified DESC',
    );
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<int> togglePinNote(int id, bool isPinned) async {
    final db = await database;
    return db.update(
      _tableName,
      {'is_pinned': isPinned ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
