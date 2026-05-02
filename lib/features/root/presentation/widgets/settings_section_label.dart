import 'package:flutter/material.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.4,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
