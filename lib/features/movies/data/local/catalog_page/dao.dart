import '../../../../../core/database/dao/base_dao.dart';
import '../../../../../core/database/database_constants.dart';
import 'entity.dart';
import 'schema.dart';

class MovieCatalogPageDao extends BaseDao<MovieCatalogPageEntity> {
  MovieCatalogPageDao(super.db);

  @override
  String get tableName => TableNames.movieCatalogPages;

  @override
  MovieCatalogPageEntity fromMap(Map<String, dynamic> map) =>
      MovieCatalogPageEntity.fromMap(map);

  /// Atomically replaces one (catalogKind, page) slice with [orderedMovieIds].
  Future<void> replacePage({
    required String catalogKind,
    required int page,
    required List<int> orderedMovieIds,
  }) async {
    await db.transaction((txn) async {
      await txn.delete(
        tableName,
        where:
            '${MovieCatalogPageSchema.catalogKind} = ? AND '
            '${MovieCatalogPageSchema.page} = ?',
        whereArgs: [catalogKind, page],
      );

      final batch = txn.batch();
      for (var i = 0; i < orderedMovieIds.length; i++) {
        batch.insert(
          tableName,
          MovieCatalogPageEntity(
            id: '${catalogKind}_${page}_$i',
            catalogKind: catalogKind,
            page: page,
            position: i,
            movieRowId: orderedMovieIds[i].toString(),
          ).toMap(),
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<MovieCatalogPageEntity>> listSlots({
    required String catalogKind,
    required int page,
  }) async {
    final rows = await db.query(
      tableName,
      where:
          '${MovieCatalogPageSchema.catalogKind} = ? AND '
          '${MovieCatalogPageSchema.page} = ?',
      whereArgs: [catalogKind, page],
      orderBy: MovieCatalogPageSchema.position,
    );
    return rows.map(fromMap).toList();
  }
}
