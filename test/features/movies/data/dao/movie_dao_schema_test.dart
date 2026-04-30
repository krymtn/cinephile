import 'package:cinephileapp/core/database/database_constants.dart';
import 'package:cinephileapp/features/movies/data/dao/movie_dao_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import 'movie_database_test_support.dart';

void main() {
  late Database db;

  setUpAll(ensureSqfliteFfiInitialized);

  setUp(() async {
    db = await openMovieTestDatabase();
  });

  tearDown(() async {
    await closeAndDeleteTestDatabase(db);
  });

  group('MovieDaoSchema', () {
    test('onCreate creates movies table with expected columns', () async {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='${MovieDaoSchema.tableName}'",
      );

      expect(tables.length, 1);
      expect(tables.first['name'], MovieDaoSchema.tableName);

      final columns = await db.rawQuery(
        'PRAGMA table_info(${MovieDaoSchema.tableName})',
      );
      final columnNames = columns.map((c) => c['name'] as String).toList();

      expect(columnNames, contains(BaseColumns.id));
      expect(columnNames, contains(MovieDaoSchema.colTitle));
      expect(columnNames, contains(MovieDaoSchema.colOverview));
      expect(columnNames, contains(MovieDaoSchema.colRating));
      expect(columnNames, contains(BaseColumns.createdAt));
      expect(columnNames, contains(BaseColumns.updatedAt));
      expect(columnNames, contains(BaseColumns.deletedAt));
      expect(columnNames, contains(BaseColumns.syncId));
      expect(columnNames, contains(BaseColumns.syncStatus));

      final idColumn = columns.firstWhere((c) => c['name'] == BaseColumns.id);
      expect(idColumn['pk'], 1);
    });

    test('title NOT NULL is enforced at SQL level', () async {
      final now = DateTime.now().toIso8601String();

      await expectLater(
        db.insert(MovieDaoSchema.tableName, {
          BaseColumns.id: 'movie_456',
          MovieDaoSchema.colOverview: 'No title',
          MovieDaoSchema.colRating: 5.0,
          BaseColumns.createdAt: now,
          BaseColumns.updatedAt: now,
          BaseColumns.syncStatus: 0,
        }),
        throwsA(isA<DatabaseException>()),
      );
    });
  });
}
