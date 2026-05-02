import 'package:flutter/material.dart';

import 'package:cinephileapp/core/preferences/keys.dart';
import 'package:cinephileapp/core/preferences/preferences.dart';

abstract interface class ThemeRepository {
  Future<ThemeMode> loadThemeMode();
  Future<void> setThemeMode(ThemeMode mode);
}

final class StoredThemeRepository implements ThemeRepository {
  StoredThemeRepository(this._preferences);

  final Preferences _preferences;

  @override
  Future<ThemeMode> loadThemeMode() async {
    final raw = await _preferences.read(PreferenceKeys.themeMode);
    return _parse(raw);
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.write(PreferenceKeys.themeMode, _serialize(mode));
  }

  static ThemeMode _parse(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _serialize(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}
