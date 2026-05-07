/// Progress callback for long-running use case work (e.g. 0.0–1.0).
typedef UseCaseProgress = void Function(double progress);

/// Base contract for application use cases: [I] in, [O] out (async).
///
/// Mirrors a small-command pattern similar to heavier “executable” helpers,
/// without tying inputs to transports (see [UseCaseInput] when JSON helps).
abstract class UseCase<I, O> {
  /// Stable id for caching, analytics, logs, dedup keys.
  String get name;

  /// Derive an id for [input]; override when `toString` is noisy or unstable.
  String keyOf(I input) => '$name::$input';

  /// Runs the operation.
  Future<O> invoke(I input, {UseCaseProgress? onProgress});
}
