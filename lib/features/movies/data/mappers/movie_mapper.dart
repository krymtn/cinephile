import '../../../../core/data/paged_dto.dart';
import '../../domain/movie.dart';
import '../../domain/paged_movies.dart';
import '../dto/movie_dto.dart';
import '../local/genre/entity.dart';
import '../local/movie/entity.dart';

/// Extension to map [MovieDto] to Domain and Entity models.
extension MovieDtoMapper on MovieDto {
  Movie toDomain() {
    return Movie(
      id: id,
      title: title,
      originalTitle: originalTitle,
      originalLanguage: originalLanguage,
      overview: overview,
      releaseDate: releaseDate != null && releaseDate!.isNotEmpty
          ? DateTime.tryParse(releaseDate!)
          : null,
      posterPath: posterPath,
      backdropPath: backdropPath,
      genreIds: genreIds,
      popularity: popularity,
      voteAverage: voteAverage,
      voteCount: voteCount,
      adult: adult,
      video: video,
    );
  }

  MovieEntity toEntity() {
    return MovieEntity(
      id: id.toString(),
      title: title,
      originalTitle: originalTitle,
      originalLanguage: originalLanguage,
      overview: overview,
      releaseDate: releaseDate,
      posterPath: posterPath,
      backdropPath: backdropPath,
      popularity: popularity,
      voteAverage: voteAverage,
      voteCount: voteCount,
      adult: adult,
      video: video,
    );
  }

  List<MovieGenreEntity> toGenreEntities() {
    return genreIds
        .map(
          (genreId) => MovieGenreEntity(
            id: '${id}_$genreId',
            movieRowId: id.toString(),
            genreId: genreId,
          ),
        )
        .toList();
  }
}

/// Extension to map [MovieEntity] to Domain models.
extension MovieEntityMapper on MovieEntity {
  Movie toDomain({List<int> genreIds = const []}) {
    return Movie(
      id: movieId,
      title: title,
      originalTitle: originalTitle,
      originalLanguage: originalLanguage,
      overview: overview,
      releaseDate: releaseDate != null && releaseDate!.isNotEmpty
          ? DateTime.tryParse(releaseDate!)
          : null,
      posterPath: posterPath,
      backdropPath: backdropPath,
      genreIds: genreIds,
      popularity: popularity,
      voteAverage: voteAverage,
      voteCount: voteCount,
      adult: adult,
      video: video,
    );
  }
}

/// Extension to map [PagedDto] of [MovieDto] to [PagedMovies].
extension PagedMovieDtoMapper on PagedDto<MovieDto> {
  PagedMovies toDomain() {
    return PagedMovies(
      movies: results.map((dto) => dto.toDomain()).toList(),
      page: page,
      totalPages: totalPages,
      totalResults: totalResults,
      windowStart: windowStart != null && windowStart!.isNotEmpty
          ? DateTime.tryParse(windowStart!)
          : null,
      windowEnd: windowEnd != null && windowEnd!.isNotEmpty
          ? DateTime.tryParse(windowEnd!)
          : null,
    );
  }
}
