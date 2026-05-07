import 'package:flutter/widgets.dart';

/// Maps persisted `language_code` preference values to supported [Locale]s:
/// `en` → `Locale('en')`, `tr` → `Locale('tr')`, anything else → `Locale('en')`.
extension StringPreferencesLanguageLocaleX on String {
  static const Locale _en = Locale('en');
  static const Locale _tr = Locale('tr');

  Locale get locale {
    switch (trim().toLowerCase()) {
      case 'en':
        return _en;
      case 'tr':
        return _tr;
      default:
        return _en;
    }
  }
}
