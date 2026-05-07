import 'package:flutter/material.dart';

class PosterCell extends StatelessWidget {
  const PosterCell({
    super.key,
    this.onTap,
    this.width = 120,
    this.aspectRatio = 2 / 3,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    required this.child,
  });

  final VoidCallback? onTap;
  final double width;
  final double aspectRatio;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Material(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AspectRatio(aspectRatio: aspectRatio, child: child),
        ),
      ),
    );
  }
}
