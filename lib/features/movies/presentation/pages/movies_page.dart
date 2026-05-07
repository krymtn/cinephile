import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../core/network/network_client.dart';
import '../../../../theme/theme_extension.dart';
import '../../../root/presentation/widgets/app_settings_sheet.dart';
import '../../data/local/catalog_meta/dao.dart';
import '../../data/local/catalog_page/dao.dart';
import '../../data/local/data_source.dart';
import '../../data/local/genre/dao.dart';
import '../../data/local/movie/dao.dart';
import '../../data/remote/data_source.dart';
import '../../data/remote/http_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/movie_catalog_kind.dart';
import '../../domain/movie_repository.dart';
import '../../domain/use_cases/use_cases.dart';
import '../cubits/cubits.dart';
import '../widgets/header/catalog_kind_chips.dart';
import '../widgets/header/popular_list.dart';
import '../widgets/movies_section_heading.dart';

/// Movies tab: catalog home with sliver-based layout (popular rail + catalog list).
class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  MovieCatalogKind _selectedCatalogKind = MovieCatalogKind.nowPlaying;

  static const int _catalogSkeletonItemCount = 12;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final database = context.read<Database>();
    final networkClient = context.read<NetworkClient>();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieLocalDataSource>(
          create: (_) => MovieLocalDataSourceImpl(
            movieDao: MovieDao(database),
            genreDao: MovieGenreDao(database),
            catalogPageDao: MovieCatalogPageDao(database),
            catalogMetaDao: MovieCatalogMetaDao(database),
          ),
        ),
        RepositoryProvider<MovieRemoteDataSource>(
          create: (_) => HttpMovieRemoteDataSource(networkClient),
        ),
        RepositoryProvider<MovieRepository>(
          create: (context) => MovieRepositoryImpl(
            localDataSource: context.read<MovieLocalDataSource>(),
            remoteDataSource: context.read<MovieRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<LoadMovieCatalogPage>(
          create: (context) =>
              LoadMovieCatalogPage(context.read<MovieRepository>()),
        ),
      ],
      child: BlocProvider(
        create: (context) => PopularMoviesCubit(
          loadMovieCatalogPage: context.read<LoadMovieCatalogPage>(),
        )..load(),
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
                      const MoviesSectionHeading(title: 'Popular'),
                      BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
                        builder: (context, state) {
                          return switch (state) {
                            PopularMoviesLoaded(:final movies) =>
                              MoviesPopularList(movies: movies),
                            PopularMoviesFailure() => const MoviesPopularListSkeleton(),
                            _ => const MoviesPopularListSkeleton(),
                          };
                        },
                      ),
                      const SizedBox(height: 28),
                      MoviesCatalogKindChips(
                        selected: _selectedCatalogKind,
                        onSelected: (kind) {
                          setState(() => _selectedCatalogKind = kind);
                        },
                      ),
                      const SizedBox(height: 20),
                      MoviesSectionHeading(
                        title: _catalogHeading(_selectedCatalogKind),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index < _catalogSkeletonItemCount - 1 ? 12 : 0,
                        ),
                        child: _CatalogRowSkeleton(index: index, colors: colors),
                      );
                    },
                    childCount: _catalogSkeletonItemCount,
                  ),
                ),
              ),
            ],
          ),
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

class _CatalogRowSkeleton extends StatelessWidget {
  const _CatalogRowSkeleton({required this.index, required this.colors});

  final int index;
  final AppThemeColors colors;

  static const double _posterWidth = 52;
  static const double _posterHeight = 78;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _posterWidth,
              height: _posterHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.posterGradA, colors.posterGradB],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catalog title ${index + 1}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2024 · Placeholder director',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              (7.2 - (index % 5) * 0.1).toStringAsFixed(1),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
