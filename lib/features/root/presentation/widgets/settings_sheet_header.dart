import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context.dart';

class SettingsSheetHeader extends StatelessWidget {
  const SettingsSheetHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.settingsTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          tooltip: context.l10n.settingsCloseSheet,
          icon: Icon(Icons.close, color: scheme.onSurface),
        ),
      ],
    );
  }
}
