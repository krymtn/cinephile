import '../../../domain/movie.dart';
import '../../../domain/movie_catalog_kind.dart';

sealed class MoviesCatalogState {
  const MoviesCatalogState({required this.selectedKind});

  final MovieCatalogKind selectedKind;
}

final class MoviesCatalogInitial extends MoviesCatalogState {
  const MoviesCatalogInitial({required super.selectedKind});
}

final class MoviesCatalogLoading extends MoviesCatalogState {
  const MoviesCatalogLoading({required super.selectedKind});
}

final class MoviesCatalogLoaded extends MoviesCatalogState {
  const MoviesCatalogLoaded({
    required super.selectedKind,
    required this.movies,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  final List<Movie> movies;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  MoviesCatalogLoaded copyWith({
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return MoviesCatalogLoaded(
      selectedKind: selectedKind,
      movies: movies ?? this.movies,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class MoviesCatalogFailure extends MoviesCatalogState {
  const MoviesCatalogFailure({
    required super.selectedKind,
    required this.error,
    this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;
}
