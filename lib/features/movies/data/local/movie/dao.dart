import '../../../../../core/database/dao/base_dao.dart';
import 'entity.dart';
import 'schema.dart';

/// Encyclopedia access through the shared [BaseDao] helpers.
class MovieDao extends BaseDao<MovieEntity> {
  MovieDao(super.db);

  @override
  String get tableName => 'movies';

  @override
  MovieEntity fromMap(Map<String, dynamic> map) => MovieEntity.fromMap(map);

  Future<MovieEntity?> getByMovieId(int movieId) async {
    final rows = await db.query(
      tableName,
      where: '${MovieSchema.id} = ?',
      whereArgs: [movieId.toString()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return fromMap(rows.single);
  }
}
