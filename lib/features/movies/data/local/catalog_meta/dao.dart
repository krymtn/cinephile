import '../../../../../core/database/dao/base_dao.dart';
import '../../../../../core/database/database_constants.dart';
import 'entity.dart';
import 'schema.dart';

class MovieCatalogMetaDao extends BaseDao<MovieCatalogMetaEntity> {
  MovieCatalogMetaDao(super.db);

  @override
  String get tableName => TableNames.movieCatalogMeta;

  @override
  MovieCatalogMetaEntity fromMap(Map<String, dynamic> map) =>
      MovieCatalogMetaEntity.fromMap(map);

  Future<void> upsert(MovieCatalogMetaEntity meta) async => insert(meta);

  Future<MovieCatalogMetaEntity?> get({
    required String catalogKind,
    required int page,
  }) async {
    final rows = await db.query(
      tableName,
      where:
          '${MovieCatalogMetaSchema.catalogKind} = ? AND '
          '${MovieCatalogMetaSchema.page} = ?',
      whereArgs: [catalogKind, page],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return fromMap(rows.single);
  }
}
