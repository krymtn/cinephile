import 'keys.dart';

abstract interface class PreferenceStore {
  Future<String?> read(PreferenceKeys key);
  Future<void> write(PreferenceKeys key, String value);
  Future<void> delete(PreferenceKeys key);
}
