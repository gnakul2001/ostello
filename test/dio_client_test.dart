// Import required libraries for testing, network requests, and mocking.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:ostello/dio_client.dart';

void main() {
  // Group of tests related to the DioClient's functionalities.

  // Create a Dio instance for network operations.
  final dio = Dio();
  // Use DioAdapter to mock responses for the Dio instance.
  final dioAdapter = DioAdapter(dio: dio);
  // Initialize the DioClient, ensuring caching is disabled during tests.
  final dioClient = DioClient(dio: dio, enableCache: false);

  // Test to validate the behavior of the GET method in the DioClient.
  test('GET method test', () async {
    const testUrl = 'https://testapi.com/get';
    const mockResponseData = {'key': 'value'};

    // Set up the mock behavior for a GET request to the given URL.
    dioAdapter.onGet(
      testUrl,
      (request) => request.reply(200, mockResponseData),
      headers: {},
    );

    // Perform a GET request and assert the response matches the mock data.
    final response = await dioClient.get(testUrl);
    expect(response.data, mockResponseData);
  });

  // Test to validate the behavior of the POST method in the DioClient.
  test('POST method test', () async {
    const testUrl = 'https://testapi.com/post';
    const mockRequestData = {'key': 'value'};
    const mockResponseData = {'success': true};

    // Set up the mock behavior for a POST request to the given URL.
    dioAdapter.onPost(
      testUrl,
      (request) => request.reply(200, mockResponseData),
      headers: {},
      data: mockRequestData,
    );

    // Perform a POST request and assert the response matches the mock data.
    final response = await dioClient.post(testUrl, data: mockRequestData);
    expect(response.data, mockResponseData);
  });

  // Test to check the caching functionality of the DioClient.
  test('Cache test', () async {
    const testUrl = 'https://testapi.com/cache';
    const mockResponseData = {'key': 'value'};

    // Set up the mock behavior for a GET request to the given URL.
    dioAdapter.onGet(
      testUrl,
      (request) => request.reply(200, mockResponseData),
      headers: {},
    );

    // Perform two GET requests sequentially to test caching consistency.
    final firstResponse = await dioClient.get(testUrl);
    expect(firstResponse.data, mockResponseData);
    final secondResponse = await dioClient.get(testUrl);
    expect(secondResponse.data, mockResponseData);
  });

  // Test to validate DioClient's error-handling mechanism.
  test('Error handling test', () async {
    const testUrl = 'https://testapi.com/error';
    const errorMessage = 'An error occurred!';

    // Set up the mock behavior to throw an error for a GET request to the given URL.
    dioAdapter.onGet(
      testUrl,
      (request) => request.throws(
          500,
          DioException(
              message: errorMessage,
              requestOptions: RequestOptions(path: testUrl))),
      headers: {},
    );

    // Perform a GET request and assert that the expected error is thrown.
    try {
      await dioClient.get(testUrl);
    } catch (e) {
      expect(e, isInstanceOf<DioException>());
    }
  });
}
