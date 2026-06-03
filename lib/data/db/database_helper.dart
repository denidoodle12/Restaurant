import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableName = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'id': restaurant.id,
        'name': restaurant.name,
        'description': restaurant.description,
        'pictureId': restaurant.pictureId,
        'city': restaurant.city,
        'rating': restaurant.rating,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: 'name ASC');
    return result.map((row) {
      return Restaurant(
        id: row['id'] as String,
        name: row['name'] as String,
        description: (row['description'] as String?) ?? '',
        pictureId: (row['pictureId'] as String?) ?? '',
        city: (row['city'] as String?) ?? '',
        rating: (row['rating'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
