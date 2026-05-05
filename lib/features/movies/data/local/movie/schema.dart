import 'package:sqflite/sqflite.dart';

import '../../../../../core/database/dao/dao_schema.dart';
import '../../../../../core/database/database_constants.dart';

final class MovieSchema extends DaoSchema {
  @override
  String get name => 'movies';

  /// Offline/sync columns
  static const id = BaseColumns.id;
  /// Movie payload columns
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

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $name (
        $id TEXT PRIMARY KEY NOT NULL,
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

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}
}