import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/dao/dao_schema.dart';
import '../../../../../core/database/database_constants.dart';

final class MovieCatalogMetaSchema extends DaoSchema {
  @override
  String get name => TableNames.movieCatalogMeta;

  static const id = BaseColumns.id;
  static const catalogKind = 'catalog_kind';
  static const page = 'page';
  static const totalPages = 'total_pages';
  static const totalResults = 'total_results';
  static const windowStart = 'window_start';
  static const windowEnd = 'window_end';
  static const fetchedAt = 'fetched_at';

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $name (
        $id TEXT PRIMARY KEY NOT NULL,
        $catalogKind TEXT NOT NULL,
        $page INTEGER NOT NULL,
        $totalPages INTEGER NOT NULL,
        $totalResults INTEGER NOT NULL,
        $windowStart TEXT,
        $windowEnd TEXT,
        $fetchedAt TEXT NOT NULL,
        UNIQUE ($catalogKind, $page)
      )
    ''');
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}
}
