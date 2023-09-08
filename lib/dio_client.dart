// Importing Dio package for making HTTP requests.
import 'package:dio/dio.dart';

// Importing Flutter Cache Manager package for caching HTTP responses.
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Defining a custom Dio client class for making HTTP requests with caching and error handling.
class DioClient {
  // Creating a Dio instance for making HTTP requests.
  Dio dio;

  // Constructor for the custom Dio client class.
  DioClient({Dio? dio, enableCache = true}) : dio = dio ?? Dio() {
    // Adding a cache interceptor to handle caching of HTTP requests.
    if (enableCache) dio?.interceptors.add(_cacheInterceptor());

    // Adding an error interceptor to handle errors during HTTP requests.
    dio?.interceptors.add(_errorInterceptor());
  }

  // Defining the cache interceptor.
  Interceptor _cacheInterceptor() {
    return InterceptorsWrapper(
      // Handling the request part of the interceptor.
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        // Trying to fetch the cached data for the given request URL.
        var cache =
            await DefaultCacheManager().getSingleFile(options.uri.toString());

        // If the cache exists for the given request URL.
        if (cache.existsSync()) {
          // Reading the cached data as a string.
          var data = await cache.readAsString();

          // Resolving the request with the cached data.
          return handler.resolve(Response(
            requestOptions: options,
            data: data,
            statusCode: 200,
          ));
        }
        // If the cache doesn't exist, proceed with the original request.
        return handler.next(options);
      },

      // Handling the response part of the interceptor.
      onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
        // Storing the response data in the cache for the given request URL.
        await DefaultCacheManager()
            .putFile(response.requestOptions.uri.toString(), response.data);

        // Continuing with the response processing.
        return handler.next(response);
      },
    );
  }

  // Defining the error interceptor.
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      // Handling errors during HTTP requests.
      onError: (DioException exception, ErrorInterceptorHandler handler) {
        // Continuing with the error handling.
        return handler.next(exception);
      },
    );
  }

  // GET method to fetch data from a given URL.
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  // POST method to send data to a given URL.
  Future<Response> post(String url,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await dio.post(url, data: data, queryParameters: queryParameters);
  }
}
