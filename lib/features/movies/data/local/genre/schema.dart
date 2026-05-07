import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/dao/dao_schema.dart';
import '../../../../../core/database/database_constants.dart';

final class MovieGenreSchema extends DaoSchema {
  @override
  String get name => TableNames.movieGenres;

  static const id = BaseColumns.id;
  static const movieId = 'movie_id';
  static const genreId = 'genre_id';

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $name (
        $id TEXT PRIMARY KEY NOT NULL,
        $movieId TEXT NOT NULL,
        $genreId INTEGER NOT NULL,
        UNIQUE ($movieId, $genreId),
        FOREIGN KEY ($movieId)
          REFERENCES ${TableNames.movies}($id) ON DELETE CASCADE
      )
    ''');
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}
}
