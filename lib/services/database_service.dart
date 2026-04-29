import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        targetDays INTEGER NOT NULL,
        progress INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        category TEXT,
        lastCompletedDate TEXT,
        isCompleted INTEGER NOT NULL,
        currentStreak INTEGER,
        bestStreak INTEGER
      )
    ''');
  }

  // FIX: Menggunakan nama getAllHabits sesuai permintaan Controller
  Future<List<Habit>> getAllHabits() async {
    final db = await instance.database;
    final result = await db.query('habits', orderBy: 'createdAt DESC');
    return result.map((json) => Habit.fromMap(json)).toList();
  }

  // FIX: Menggunakan nama insertHabit sesuai permintaan Controller
  Future<int> insertHabit(Habit habit) async {
    final db = await instance.database;
    return await db.insert('habits', habit.toMap());
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}