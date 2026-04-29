import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:cinephileapp/core/network/network_client.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late NetworkClient networkClient;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3'));
    dioAdapter = DioAdapter(dio: dio);
    networkClient = NetworkClient(dio);
  });

  test('get returns data from mock json', () async {
    // Read the local JSON file
    final file = File('test/fixtures/now_playing.json');
    final jsonString = await file.readAsString();
    final mockData = jsonDecode(jsonString);

    // Setup the mock adapter
    dioAdapter.onGet(
      '/movie/now_playing',
      (server) => server.reply(200, mockData),
    );

    // Call the network client
    final response = await networkClient.get('/movie/now_playing');

    // Verify the response
    expect(response.statusCode, 200);
    expect(response.data, isA<Map<String, dynamic>>());
    expect(response.data['results'], isNotEmpty);
    expect(response.data['results'][0]['title'], 'Apex');
  });
}
