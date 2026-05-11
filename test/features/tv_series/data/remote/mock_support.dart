import 'package:flutter_test/flutter_test.dart';

import 'package:cinephileapp/features/tv_series/data/remote/mock_data_source.dart';

void ensureTvSeriesMockAssetsBinding() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

MockTvSeriesRemoteDataSource createMockTvSeriesRemoteDataSource() {
  return MockTvSeriesRemoteDataSource(latency: Duration.zero);
}
