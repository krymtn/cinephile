/// Enum for SharedPreferences keys with type safety
enum PreferenceKeys {
  // User related
  themeMode('theme_mode'), 
  languageCode('language_code');

  const PreferenceKeys(this.key);
  final String key;
}

