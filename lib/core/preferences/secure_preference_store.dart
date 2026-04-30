// secure_preference_store.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'keys.dart';
import 'preference_store.dart';

/// Production: delegates to [FlutterSecureStorage].
final class SecurePreferenceStore implements PreferenceStore {
  SecurePreferenceStore(this._storage);
  final FlutterSecureStorage _storage;
  @override
  Future<String?> read(PreferenceKeys key) => _storage.read(key: key.key);
  @override
  Future<void> write(PreferenceKeys key, String value) =>
      _storage.write(key: key.key, value: value);
  @override
  Future<void> delete(PreferenceKeys key) => _storage.delete(key: key.key);
}
