import 'package:flutter/material.dart';

/// Persists and loads the app UI [Locale] (see `language_code` preference).
abstract interface class LocaleRepository {
  Future<Locale> loadLocale();

  Future<void> setLanguageCode(String code);
}
