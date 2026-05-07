import '../../../../../core/database/models/base_entity.dart';
import 'schema.dart';

class MovieGenreEntity extends BaseEntity {
  MovieGenreEntity({
    required this.id,
    required this.movieRowId,
    required this.genreId,
  });

  @override
  final String id;

  /// Same digits as the linked [MovieSchema] row id.
  final String movieRowId;
  final int genreId;

  @override
  Map<String, dynamic> toMap() {
    return {
      MovieGenreSchema.id: id,
      MovieGenreSchema.movieId: movieRowId,
      MovieGenreSchema.genreId: genreId,
    };
  }

  factory MovieGenreEntity.fromMap(Map<String, dynamic> map) {
    return MovieGenreEntity(
      id: map[MovieGenreSchema.id] as String,
      movieRowId: map[MovieGenreSchema.movieId] as String,
      genreId: map[MovieGenreSchema.genreId] as int,
    );
  }
}
