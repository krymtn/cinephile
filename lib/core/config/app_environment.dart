enum AppEnvironment {
  dev('dev'),
  staging('staging'),
  prod('prod');

  const AppEnvironment(this.value);

  final String value;

  static AppEnvironment fromValue(String raw) =>
      AppEnvironment.values.firstWhere(
        (e) => e.value == raw,
        orElse: () => AppEnvironment.dev,
      );
}

extension AppEnvironmentX on AppEnvironment {
  bool get isDev => this == AppEnvironment.dev;

  bool get isStaging => this == AppEnvironment.staging;

  bool get isProd => this == AppEnvironment.prod;

  bool get isNotProd => !isProd;

  /// Exhaustive branching on environment (compile-time checks when cases are exhaustive).
  T when<T>({
    required T Function() dev,
    required T Function() staging,
    required T Function() prod,
  }) {
    switch (this) {
      case AppEnvironment.dev:
        return dev();
      case AppEnvironment.staging:
        return staging();
      case AppEnvironment.prod:
        return prod();
    }
  }
}
