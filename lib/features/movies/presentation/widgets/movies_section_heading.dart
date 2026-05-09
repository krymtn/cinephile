import 'package:flutter/material.dart';

/// Small uppercase section label (e.g. POPULAR, NOW PLAYING).
class MoviesSectionHeading extends StatelessWidget {
  const MoviesSectionHeading({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllText = 'See all',
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: Text(seeAllText)),
        ],
      ),
    );
  }
}
