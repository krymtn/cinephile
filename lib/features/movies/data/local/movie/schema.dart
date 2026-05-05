import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/database_constants.dart';

/// SQLite identifiers + `CREATE TABLE` for the TMDB encyclopedia (`movies`).
///
/// DDL only — no [DaoSchema] registration or version migrations in this layer.
abstract final class MoviesTable {
  static const name = 'movies';

  static const id = BaseColumns.id;
  static const title = 'title';
  static const originalTitle = 'original_title';
  static const originalLanguage = 'original_language';
  static const overview = 'overview';
  static const releaseDate = 'release_date';
  static const posterPath = 'poster_path';
  static const backdropPath = 'backdrop_path';
  static const popularity = 'popularity';
  static const voteAverage = 'vote_average';
  static const voteCount = 'vote_count';
  static const adult = 'adult';
  static const video = 'video';

  static Future<void> create(Database db) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS $name (
  $id TEXT PRIMARY KEY NOT NULL,
  ${BaseColumns.createdAt} TEXT NOT NULL,
  ${BaseColumns.updatedAt} TEXT NOT NULL,
  ${BaseColumns.deletedAt} TEXT,
  ${BaseColumns.syncId} TEXT,
  ${BaseColumns.syncStatus} INTEGER NOT NULL DEFAULT 0,
  $title TEXT NOT NULL,
  $originalTitle TEXT,
  $originalLanguage TEXT,
  $overview TEXT,
  $releaseDate TEXT,
  $posterPath TEXT,
  $backdropPath TEXT,
  $popularity REAL NOT NULL DEFAULT 0,
  $voteAverage REAL NOT NULL DEFAULT 0,
  $voteCount INTEGER NOT NULL DEFAULT 0,
  $adult INTEGER NOT NULL DEFAULT 0,
  $video INTEGER NOT NULL DEFAULT 0
)
''');
  }
}
