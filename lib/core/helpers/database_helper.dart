import 'package:available/core/interfaces/model.dart';
import 'package:available/core/utils/typedefs.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database db;

  static const createUserTableQuery = '''
    CREATE TABLE users(
      id TEXT NOT NULL,
      studentEmail TEXT NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      courseId TEXT NOT NULL,
      courseName TEXT NOT NULL,
      facultyId TEXT NOT NULL,
      facultyName TEXT NOT NULL,
      indexNumber TEXT NOT NULL,
      levelId TEXT NOT NULL,
      levelName TEXT NOT NULL
    )
  ''';

  Future<void> open(String path) async {
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(createUserTableQuery);
      },
    );
  }

  Future<int> insert<T extends Model>(T model) async {
    final result = await db.insert(
      'users',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<DataMap?> get({
    required String table,
    required String key,
    required String value,
  }) async {
    final result = await db.query(
      table,
      where: '$key = ?',
      whereArgs: [value],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first;
  }
}
