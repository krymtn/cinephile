import 'package:flutter/material.dart';

import '../../../domain/movie_catalog_kind.dart';

typedef CatalogKindCallback = void Function(MovieCatalogKind kind);

/// Chip row driving the catalog section (not the popular carousel).
///
/// Uses a bounded-height horizontal list so the row lays out inside a [Column]
/// (e.g. under [SliverToBoxAdapter]); an unbounded [SingleChildScrollView]
/// there can collapse to zero height.
class MoviesCatalogKindChips extends StatefulWidget {
  const MoviesCatalogKindChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MovieCatalogKind selected;
  final CatalogKindCallback onSelected;

  static const List<MovieCatalogKind> _order = [
    MovieCatalogKind.nowPlaying,
    MovieCatalogKind.popular,
    MovieCatalogKind.topRated,
    MovieCatalogKind.upcoming,
  ];

  static const double _rowHeight = 48;

  @override
  State<MoviesCatalogKindChips> createState() => _MoviesCatalogKindChipsState();

  static String _label(MovieCatalogKind kind) {
    return switch (kind) {
      MovieCatalogKind.nowPlaying => 'Now playing',
      MovieCatalogKind.popular => 'Popular',
      MovieCatalogKind.topRated => 'Top rated',
      MovieCatalogKind.upcoming => 'Upcoming',
    };
  }
}

class _MoviesCatalogKindChipsState extends State<MoviesCatalogKindChips> {
  late MovieCatalogKind _selected = widget.selected;

  @override
  void didUpdateWidget(covariant MoviesCatalogKindChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected && _selected != widget.selected) {
      _selected = widget.selected;
    }
  }

  void _select(MovieCatalogKind kind) {
    if (_selected == kind) return;
    setState(() => _selected = kind);
    widget.onSelected(kind);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final dim = scheme.surfaceContainerHigh;

    return SizedBox(
      height: MoviesCatalogKindChips._rowHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: MoviesCatalogKindChips._order.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final kind = MoviesCatalogKindChips._order[index];
          final isSelected = _selected == kind;
          return ChoiceChip(
            // Changing the key when selection flips resets RawChip's internal
            // animation state, removing the "flush" transition.
            key: ValueKey('${kind.name}-$isSelected'),
            label: Text(MoviesCatalogKindChips._label(kind)),
            selected: isSelected,
            onSelected: (_) => _select(kind),
            showCheckmark: false,
            selectedColor: accent.withValues(alpha: 0.2),
            backgroundColor: dim,
            labelStyle: TextStyle(
              color: isSelected ? accent : scheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? accent : scheme.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
