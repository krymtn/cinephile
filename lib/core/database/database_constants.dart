class DatabaseConstants {
  static const String databaseName = 'cinephile.db';
  static const int databaseVersion = 1;
}

class BaseColumns {
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String deletedAt = 'deletedAt';
  static const String syncId = 'syncId';
  static const String syncStatus = 'syncStatus';
}

/// Canonical SQLite table names for every feature. Import from core so any
/// layer (migrations, raw queries, tests) can reference them without reaching
/// into feature-specific schema files.
class TableNames {
  // movies feature
  static const String movies = 'movies';
  static const String movieGenres = 'movie_genres';
  static const String movieCatalogPages = 'movie_catalog_pages';
  static const String movieCatalogMeta = 'movie_catalog_meta';
}
