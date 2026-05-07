import '../../../domain/movie.dart';

sealed class PopularMoviesState {
  const PopularMoviesState();
}

final class PopularMoviesInitial extends PopularMoviesState {
  const PopularMoviesInitial();
}

final class PopularMoviesLoading extends PopularMoviesState {
  const PopularMoviesLoading();
}

final class PopularMoviesLoaded extends PopularMoviesState {
  const PopularMoviesLoaded(this.movies);

  final List<Movie> movies;
}

final class PopularMoviesFailure extends PopularMoviesState {
  const PopularMoviesFailure(this.error, {this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;
}
