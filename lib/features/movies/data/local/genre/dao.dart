import '../../../../../core/database/dao/base_dao.dart';
import '../../../../../core/database/database_constants.dart';
import 'entity.dart';
import 'schema.dart';

class MovieGenreDao extends BaseDao<MovieGenreEntity> {
  MovieGenreDao(super.db);

  @override
  String get tableName => TableNames.movieGenres;

  @override
  MovieGenreEntity fromMap(Map<String, dynamic> map) =>
      MovieGenreEntity.fromMap(map);

  /// Replaces all genre rows for [movieId] atomically.
  Future<void> replaceForMovie(int movieId, List<int> genreIds) async {
    final rowId = movieId.toString();
    final batch = db.batch()
      ..delete(
        tableName,
        where: '${MovieGenreSchema.movieId} = ?',
        whereArgs: [rowId],
      );
    for (final gid in genreIds) {
      batch.insert(
        tableName,
        MovieGenreEntity(id: '${rowId}_$gid', movieRowId: rowId, genreId: gid)
            .toMap(),
      );
    }
    await batch.commit(noResult: true);
  }
}
