import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/movie_catalog_kind.dart';
import '../../../domain/use_cases/load_movie_catalog_page.dart';
import '../../../domain/use_cases/movie_catalog_page_input.dart';
import 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit({
    required LoadMovieCatalogPage loadMovieCatalogPage,
    this.page = 1,
  }) : _loadMovieCatalogPage = loadMovieCatalogPage,
       super(const PopularMoviesInitial());

  final LoadMovieCatalogPage _loadMovieCatalogPage;
  final int page;

  Future<void> load() async {
    if (state is PopularMoviesLoading) return;
    emit(const PopularMoviesLoading());
    try {
      final result = await _loadMovieCatalogPage.invoke(
        MovieCatalogPageInput(kind: MovieCatalogKind.popular, page: page),
      );
      emit(PopularMoviesLoaded(result.movies));
    } catch (e, st) {
      emit(PopularMoviesFailure(e, stackTrace: st));
    }
  }

  Future<void> refresh() => load();
}

