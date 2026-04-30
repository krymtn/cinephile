import 'package:cinephileapp/core/database/database_constants.dart';
import 'package:cinephileapp/features/movies/data/dao/movie_dao.dart';
import 'package:cinephileapp/features/movies/data/dao/movie_dao_schema.dart';
import 'package:cinephileapp/features/movies/data/models/movie_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import 'movie_database_test_support.dart';

void main() {
  late Database db;
  late MovieDao dao;

  setUpAll(ensureSqfliteFfiInitialized);

  setUp(() async {
    db = await openMovieTestDatabase();
    dao = MovieDao(db);
  });

  tearDown(() async {
    await closeAndDeleteTestDatabase(db);
  });

  group('MovieDao', () {
    MovieEntity sampleMovie({
      String id = 'm1',
      String title = 'Test',
      DateTime? createdAt,
      DateTime? updatedAt,
    }) {
      final t = createdAt ?? DateTime.utc(2024, 1, 1);
      final u = updatedAt ?? t;
      return MovieEntity(
        id: id,
        title: title,
        overview: 'Overview',
        rating: 7.5,
        createdAt: t,
        updatedAt: u,
        syncStatus: 0,
      );
    }

    test('insert then getAll returns the movie', () async {
      await dao.insert(sampleMovie());

      final all = await dao.getAll();
      expect(all, hasLength(1));
      expect(all.single.id, 'm1');
      expect(all.single.title, 'Test');
      expect(all.single.rating, 7.5);
    });

    test('update persists changes', () async {
      await dao.insert(sampleMovie());
      final updated = MovieEntity(
        id: 'm1',
        title: 'Updated',
        overview: 'New overview',
        rating: 9.0,
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 6, 1),
        syncStatus: 0,
      );
      await dao.update(updated);

      final all = await dao.getAll();
      expect(all.single.title, 'Updated');
      expect(all.single.overview, 'New overview');
      expect(all.single.rating, 9.0);
    });

    test('softDelete excludes row from getAll but keeps row in table', () async {
      await dao.insert(sampleMovie());

      await dao.softDelete('m1');

      expect(await dao.getAll(), isEmpty);

      final rows = await db.query(
        MovieDaoSchema.tableName,
        where: '${BaseColumns.id} = ?',
        whereArgs: ['m1'],
      );
      expect(rows, hasLength(1));
      expect(rows.single[BaseColumns.deletedAt], isNotNull);
      expect(rows.single[BaseColumns.syncStatus], 3);
      expect(rows.single[BaseColumns.syncId], isNotNull);
    });

    test('hardDelete removes row', () async {
      await dao.insert(sampleMovie());
      await dao.hardDelete('m1');

      final rows = await db.query(MovieDaoSchema.tableName);
      expect(rows, isEmpty);
    });

    test('getModifiedSince returns only rows updated after cutoff', () async {
      final old = DateTime.utc(2024, 1, 1);
      final newer = DateTime.utc(2024, 3, 1);
      await dao.insert(
        sampleMovie(id: 'a', title: 'A', createdAt: old, updatedAt: old),
      );
      await dao.insert(
        sampleMovie(id: 'b', title: 'B', createdAt: old, updatedAt: newer),
      );

      final modified = await dao.getModifiedSince(DateTime.utc(2024, 2, 1));
      expect(modified.map((e) => e.id).toList(), ['b']);
    });

    test('insert with same id replaces via conflict algorithm', () async {
      await dao.insert(sampleMovie(title: 'First'));
      await dao.insert(sampleMovie(title: 'Second'));

      final all = await dao.getAll();
      expect(all, hasLength(1));
      expect(all.single.title, 'Second');
    });
  });
}
