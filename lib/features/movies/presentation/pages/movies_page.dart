import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../theme/theme_extension.dart';
import '../../../root/presentation/widgets/app_settings_sheet.dart';
import '../../domain/movie_catalog_kind.dart';
import '../../domain/use_cases/use_cases.dart';
import '../cubits/cubits.dart';
import '../widgets/header/catalog_kind_chips.dart';
import '../widgets/header/popular_list.dart';
import '../widgets/movies_section_heading.dart';
import '../widgets/padding/movie_cell.dart';
import 'movies_catalog_list_page.dart';

/// Movies tab: catalog home with sliver-based layout (popular rail + catalog list).
class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  static const int _catalogSkeletonItemCount = 12;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PopularMoviesCubit(
            loadMovieCatalogPage: context.read<LoadMovieCatalogPage>(),
          )..load(),
        ),
        BlocProvider(
          create: (context) => MoviesCatalogCubit(
            loadMovieCatalogPage: context.read<LoadMovieCatalogPage>(),
            syncMovieCatalogPage: context.read<SyncMovieCatalogPage>(),
          )..loadInitial(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.navMovies),
          actions: [
            IconButton(
              onPressed: () => showAppSettingsSheet(context),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    MoviesSectionHeading(
                      title: 'Popular',
                      onSeeAll: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MoviesCatalogListPage(
                              kind: MovieCatalogKind.popular,
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
                      builder: (context, state) {
                        return switch (state) {
                          PopularMoviesLoaded(:final movies) =>
                            MoviesPopularList(movies: movies),
                          PopularMoviesFailure() =>
                            const MoviesPopularListSkeleton(),
                          _ => const MoviesPopularListSkeleton(),
                        };
                      },
                    ),
                    const SizedBox(height: 28),
                    BlocBuilder<MoviesCatalogCubit, MoviesCatalogState>(
                      builder: (context, state) {
                        return MoviesCatalogKindChips(
                          selected: state.selectedKind,
                          onSelected: (kind) {
                            context.read<MoviesCatalogCubit>().selectKind(kind);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<MoviesCatalogCubit, MoviesCatalogState>(
                      builder: (context, state) {
                        return MoviesSectionHeading(
                          title: _catalogHeading(state.selectedKind),
                          onSeeAll: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MoviesCatalogListPage(
                                  kind: state.selectedKind,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: BlocBuilder<MoviesCatalogCubit, MoviesCatalogState>(
                builder: (context, state) {
                  return switch (state) {
                    MoviesCatalogLoaded(:final movies) => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index < movies.length - 1 ? 12 : 0,
                          ),
                          child: MovieCell(movie: movies[index]),
                        ),
                        childCount: movies.length,
                      ),
                    ),
                    MoviesCatalogFailure() => SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        MovieCellSkeleton(colors: colors),
                      ]),
                    ),
                    _ => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _catalogSkeletonItemCount - 1
                                ? 12
                                : 0,
                          ),
                          child: MovieCellSkeleton(colors: colors),
                        ),
                        childCount: _catalogSkeletonItemCount,
                      ),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _catalogHeading(MovieCatalogKind kind) {
    return switch (kind) {
      MovieCatalogKind.nowPlaying => 'Now playing',
      MovieCatalogKind.popular => 'Popular',
      MovieCatalogKind.topRated => 'Top rated',
      MovieCatalogKind.upcoming => 'Upcoming',
    };
  }
}
