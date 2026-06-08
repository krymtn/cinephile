import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../theme/theme_extension.dart';

/// Shimmer placeholder matching [MediaRowCell] layout.
class MediaRowSkeleton extends StatelessWidget {
  const MediaRowSkeleton({
    super.key,
    this.thumbWidth = 52,
    this.thumbHeight = 78,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final double thumbWidth;
  final double thumbHeight;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final scheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surfaceContainerHigh,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: borderRadius,
          border: Border.all(color: scheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: thumbWidth,
                height: thumbHeight,
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
                    Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 160,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 16,
                width: 28,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
