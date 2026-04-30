import 'package:sqflite/sqflite.dart';
import '../../../../core/database/dao/dao_schema.dart';
import '../../../../core/database/dao/base_dao.dart';
import '../../../../core/database/database_constants.dart';

class MovieDaoSchema implements DaoSchema {
  static const String tableName = 'movies';

  static const String colTitle = 'title';
  static const String colOverview = 'overview';
  static const String colRating = 'rating';

  static const String _createTableQuery = '''
    CREATE TABLE $tableName (
      ${BaseColumns.id} TEXT PRIMARY KEY,
      $colTitle TEXT NOT NULL,
      $colOverview TEXT,
      $colRating REAL DEFAULT 0.0,
      ${BaseDao.baseColumns}
    )
  ''';

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute(_createTableQuery);
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implement migrations here as needed when version increases
  }

  @override
  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    // Default implementation does nothing
  }
}
