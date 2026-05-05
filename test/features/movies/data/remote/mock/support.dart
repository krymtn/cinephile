import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/movies/data/remote/mock_data_source.dart';

/// Call once per test library so [rootBundle] can load `assets/mocks/movies/`.
void ensureMovieMockAssetsBinding() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

MockMovieRemoteDataSource createMockMovieRemoteDataSource() {
  return MockMovieRemoteDataSource(latency: Duration.zero);
}
