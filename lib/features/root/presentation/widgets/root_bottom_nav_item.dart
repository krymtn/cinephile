import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context.dart';
import '../../../../theme/theme_extension.dart';
import '../../domain/root_tab.dart';

class RootBottomNavItem extends StatelessWidget {
  const RootBottomNavItem({
    super.key,
    required this.tab,
    required this.selected,
    required this.onSelect,
  });

  final RootTab tab;
  final RootTab selected;
  final ValueChanged<RootTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accentDim = context.appThemeColors.accentDim;
    final isActive = tab == selected;
    final activeColor = scheme.primary;
    final idleColor = scheme.onSurfaceVariant;

    final l10n = context.l10n;
    final (IconData icon, String label) = switch (tab) {
      RootTab.movies => (Icons.movie_outlined, l10n.navMovies),
      RootTab.search => (Icons.search_rounded, l10n.navSearch),
      RootTab.myList => (Icons.format_list_bulleted_rounded, l10n.navMyList),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(tab),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? accentDim : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive ? activeColor : idleColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: isActive ? activeColor : idleColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
