import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/movie_catalog_kind.dart';
import '../../../domain/use_cases/load_movie_catalog_page.dart';
import '../../../domain/use_cases/movie_catalog_page_input.dart';
import '../../../domain/use_cases/sync_movie_catalog_page.dart';
import 'movies_catalog_state.dart';

class MoviesCatalogCubit extends Cubit<MoviesCatalogState> {
  MoviesCatalogCubit({
    required LoadMovieCatalogPage loadMovieCatalogPage,
    required SyncMovieCatalogPage syncMovieCatalogPage,
    MovieCatalogKind initialKind = MovieCatalogKind.nowPlaying,
  }) : _loadMovieCatalogPage = loadMovieCatalogPage,
       _syncMovieCatalogPage = syncMovieCatalogPage,
       super(MoviesCatalogInitial(selectedKind: initialKind));

  final LoadMovieCatalogPage _loadMovieCatalogPage;
  final SyncMovieCatalogPage _syncMovieCatalogPage;

  /// Uses cache-first loading (falls back to sync on cache miss).
  Future<void> selectKind(MovieCatalogKind kind) => _load(kind);

  Future<void> loadInitial() => _load(state.selectedKind);

  /// Forces a server refresh + local persistence.
  Future<void> refresh() => _sync(state.selectedKind);

  Future<void> _load(MovieCatalogKind kind) async {
    emit(MoviesCatalogLoading(selectedKind: kind));
    try {
      final page = await _loadMovieCatalogPage.invoke(
        MovieCatalogPageInput(kind: kind, page: 1),
      );
      emit(MoviesCatalogLoaded(selectedKind: kind, movies: page.movies));
    } catch (e, st) {
      emit(
        MoviesCatalogFailure(
          selectedKind: kind,
          error: e,
          stackTrace: st,
        ),
      );
    }
  }

  Future<void> _sync(MovieCatalogKind kind) async {
    emit(MoviesCatalogLoading(selectedKind: kind));
    try {
      final page = await _syncMovieCatalogPage.invoke(
        MovieCatalogPageInput(kind: kind, page: 1),
      );
      emit(MoviesCatalogLoaded(selectedKind: kind, movies: page.movies));
    } catch (e, st) {
      emit(
        MoviesCatalogFailure(
          selectedKind: kind,
          error: e,
          stackTrace: st,
        ),
      );
    }
  }
}

