// preferences.dart
import 'keys.dart';
import 'preference_store.dart';

/// App-facing API: read / write / delete by [PreferenceKeys] only.
final class Preferences {
  Preferences(this._preference);
  final PreferenceStore _preference;
  Future<String?> read(PreferenceKeys key) async {
    try {
      return await _preference.read(key);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(PreferenceKeys key, String value) async {
    try {
      await _preference.write(key, value);
    } catch (_) {
      // log if needed
    }
  }

  Future<void> delete(PreferenceKeys key) async {
    try {
      await _preference.delete(key);
    } catch (_) {
      // log if needed
    }
  }
}

/// Default [PreferenceKeys.languageCode] when nothing is stored yet.
const kDefaultAppLanguageCode = 'en';

extension PreferencesLanguageCodeX on Preferences {
  /// Returns the stored language code, or writes and returns [fallback] when absent or blank.
  Future<String> readLanguageCodeWithDefault([
    String fallback = kDefaultAppLanguageCode,
  ]) async {
    final stored = await read(PreferenceKeys.languageCode);
    if (stored != null && stored.trim().isNotEmpty) {
      return stored.trim();
    }
    await write(PreferenceKeys.languageCode, fallback);
    return fallback;
  }
}
