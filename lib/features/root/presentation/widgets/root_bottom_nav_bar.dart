import 'package:flutter/material.dart';

import '../../domain/root_tab.dart';
import 'root_bottom_nav_item.dart';

class RootBottomNavBar extends StatelessWidget {
  const RootBottomNavBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final RootTab selected;
  final ValueChanged<RootTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 1, thickness: 1, color: scheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
              child: Row(
                children: [
                  for (final tab in RootTab.values) ...[
                    if (tab != RootTab.values.first) const SizedBox(width: 4),
                    Expanded(
                      child: RootBottomNavItem(
                        tab: tab,
                        selected: selected,
                        onSelect: onSelect,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
