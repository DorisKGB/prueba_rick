import 'package:dio/dio.dart';

class SimpleCacheInterceptor extends Interceptor {
  // Static map to keep cache across different Dio instances
  static final Map<String, Response> _cache = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method == 'GET') {
      final key = options.uri.toString();
      if (_cache.containsKey(key)) {
        final cachedResponse = _cache[key]!;
        // Return cached response immediately, skipping network
        handler.resolve(cachedResponse);
        return;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      _cache[response.requestOptions.uri.toString()] = response;
    }
    handler.next(response);
  }
}
