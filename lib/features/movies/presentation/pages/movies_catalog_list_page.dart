import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/theme_extension.dart';
import '../../domain/movie_catalog_kind.dart';
import '../../domain/use_cases/use_cases.dart';
import '../cubits/cubits.dart';
import '../widgets/padding/movie_cell.dart';

class MoviesCatalogListPage extends StatelessWidget {
  const MoviesCatalogListPage({super.key, required this.kind, this.title});

  final MovieCatalogKind kind;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;

    return BlocProvider(
      create: (context) => MoviesCatalogCubit(
        loadMovieCatalogPage: context.read<LoadMovieCatalogPage>(),
        syncMovieCatalogPage: context.read<SyncMovieCatalogPage>(),
        initialKind: kind,
      )..loadInitial(),
      child: _MoviesCatalogListScaffold(
        title: title ?? _titleFor(kind),
        colors: colors,
      ),
    );
  }

  static String _titleFor(MovieCatalogKind kind) {
    return switch (kind) {
      MovieCatalogKind.nowPlaying => 'Now playing',
      MovieCatalogKind.popular => 'Popular',
      MovieCatalogKind.topRated => 'Top rated',
      MovieCatalogKind.upcoming => 'Upcoming',
    };
  }
}

class _MoviesCatalogListScaffold extends StatefulWidget {
  const _MoviesCatalogListScaffold({required this.title, required this.colors});

  final String title;
  final AppThemeColors colors;

  @override
  State<_MoviesCatalogListScaffold> createState() =>
      _MoviesCatalogListScaffoldState();
}

class _MoviesCatalogListScaffoldState
    extends State<_MoviesCatalogListScaffold> {
  late final ScrollController _controller = ScrollController()
    ..addListener(_onScroll);

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.maxScrollExtent == 0) return;

    // Load more when we're close to the bottom.
    if (position.pixels >= position.maxScrollExtent - 320) {
      context.read<MoviesCatalogCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<MoviesCatalogCubit>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<MoviesCatalogCubit, MoviesCatalogState>(
        builder: (context, state) {
          return switch (state) {
            MoviesCatalogLoaded(:final movies, :final isLoadingMore) =>
              ListView.separated(
                controller: _controller,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                itemCount: movies.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= movies.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return MovieCell(movie: movies[index]);
                },
              ),
            MoviesCatalogFailure() => ListView(
              controller: _controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                MovieCellSkeleton(colors: widget.colors),
                const SizedBox(height: 12),
                MovieCellSkeleton(colors: widget.colors),
                const SizedBox(height: 12),
                MovieCellSkeleton(colors: widget.colors),
              ],
            ),
            _ => ListView(
              controller: _controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                MovieCellSkeleton(colors: widget.colors),
                const SizedBox(height: 12),
                MovieCellSkeleton(colors: widget.colors),
                const SizedBox(height: 12),
                MovieCellSkeleton(colors: widget.colors),
                const SizedBox(height: 12),
                MovieCellSkeleton(colors: widget.colors),
                const SizedBox(height: 12),
                MovieCellSkeleton(colors: widget.colors),
              ],
            ),
          };
        },
      ),
    );
  }
}
