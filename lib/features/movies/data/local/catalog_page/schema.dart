import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/dao/dao_schema.dart';
import '../../../../../core/database/database_constants.dart';

final class MovieCatalogPageSchema extends DaoSchema {
  @override
  String get name => TableNames.movieCatalogPages;

  static const id = BaseColumns.id;
  static const catalogKind = 'catalog_kind';
  static const page = 'page';
  static const position = 'position';
  static const movieId = 'movie_id';

  static const _indexLookup = 'idx_movie_catalog_pages_lookup';

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $name (
        $id TEXT PRIMARY KEY NOT NULL,
        $catalogKind TEXT NOT NULL,
        $page INTEGER NOT NULL,
        $position INTEGER NOT NULL,
        $movieId TEXT NOT NULL,
        UNIQUE ($catalogKind, $page, $position),
        FOREIGN KEY ($movieId)
          REFERENCES ${TableNames.movies}($id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS $_indexLookup
        ON $name ($catalogKind, $page)
    ''');
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}
}
