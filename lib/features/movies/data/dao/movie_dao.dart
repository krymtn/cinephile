import '../../../../core/database/dao/base_dao.dart';
import 'movie_dao_schema.dart';
import '../models/movie_entity.dart';

class MovieDao extends BaseDao<MovieEntity> {
  MovieDao(super.db);

  @override
  String get tableName => MovieDaoSchema.tableName;

  @override
  MovieEntity fromMap(Map<String, dynamic> map) {
    return MovieEntity.fromMap(map);
  }
}
