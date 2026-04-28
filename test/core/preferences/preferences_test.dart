import 'package:flutter_test/flutter_test.dart';
import 'package:cinephileapp/core/preferences/preference_store.dart';
import 'package:cinephileapp/core/preferences/keys.dart';
import 'package:cinephileapp/core/preferences/preferences.dart';

/// A simple in-memory mock implementation of [PreferenceStore] for testing.
class MockPreference implements PreferenceStore {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read(PreferenceKeys key) async {
    return _storage[key.key];
  }

  @override
  Future<void> write(PreferenceKeys key, String value) async {
    _storage[key.key] = value;
  }

  @override
  Future<void> delete(PreferenceKeys key) async {
    _storage.remove(key.key);
  }

  // Helper method to check if storage is empty
  bool get isEmpty => _storage.isEmpty;
}

/// A mock implementation that throws exceptions to test error handling.
class ErrorThrowingMockPreference implements PreferenceStore {
  @override
  Future<String?> read(PreferenceKeys key) async {
    throw Exception('Read error');
  }

  @override
  Future<void> write(PreferenceKeys key, String value) async {
    throw Exception('Write error');
  }

  @override
  Future<void> delete(PreferenceKeys key) async {
    throw Exception('Delete error');
  }
}

void main() {
  group('Preferences', () {
    late MockPreference mockPreference;
    late Preferences preferences;

    setUp(() {
      mockPreference = MockPreference();
      preferences = Preferences(mockPreference);
    });

    test('read returns null when key does not exist', () async {
      final result = await preferences.read(PreferenceKeys.themeMode);
      expect(result, isNull);
    });

    test('write saves the value and read retrieves it', () async {
      await preferences.write(PreferenceKeys.themeMode, 'dark');
      
      final result = await preferences.read(PreferenceKeys.themeMode);
      expect(result, equals('dark'));
    });

    test('delete removes the value', () async {
      // Setup initial value
      await preferences.write(PreferenceKeys.themeMode, 'dark');
      expect(await preferences.read(PreferenceKeys.themeMode), equals('dark'));

      // Delete the value
      await preferences.delete(PreferenceKeys.themeMode);
      
      // Verify it's gone
      final result = await preferences.read(PreferenceKeys.themeMode);
      expect(result, isNull);
      expect(mockPreference.isEmpty, isTrue);
    });

    group('Error handling', () {
      late Preferences errorPreferences;

      setUp(() {
        errorPreferences = Preferences(ErrorThrowingMockPreference());
      });

      test('read catches exceptions and returns null', () async {
        final result = await errorPreferences.read(PreferenceKeys.themeMode);
        expect(result, isNull);
      });

      test('write catches exceptions and completes normally', () async {
        // Should not throw
        await expectLater(
          errorPreferences.write(PreferenceKeys.themeMode, 'dark'),
          completes,
        );
      });

      test('delete catches exceptions and completes normally', () async {
        // Should not throw
        await expectLater(
          errorPreferences.delete(PreferenceKeys.themeMode),
          completes,
        );
      });
    });
  });
}
