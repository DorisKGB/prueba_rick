import 'package:dio/dio.dart';
import 'package:prueba_rick/infraestructure/remote/api/simple_cache_interceptor.dart';

enum BaseUrlApi { rick, labelary }

class Api {
  static Api? _instance;

  Api._internal();

  static Api instance() {
    _instance ??= Api._internal();
    return _instance!;
  }

  Future<Response<T>> post<T>({
    required String path,
    dynamic data,
    BaseUrlApi urlApi = BaseUrlApi.rick,
    bool authorization = true,
    void Function(int, int)? onSendProgress,
  }) async {
    final Dio dio = Dio();
    dio.options = await _generateBaseOptions(authorization, urlApi, path);
    return dio.post<T>(path, data: data, onSendProgress: onSendProgress);
  }

  Future<Response<T>> delete<T>({
    required String path,
    dynamic data,
    BaseUrlApi urlApi = BaseUrlApi.rick,
    bool authorization = true,
  }) async {
    final Dio dio = Dio();
    dio.options = await _generateBaseOptions(authorization, urlApi, path);
    return dio.delete<T>(path, data: data);
  }

  Future<Response<T>> put<T>({
    required String path,
    dynamic data,
    BaseUrlApi urlApi = BaseUrlApi.rick,
    bool authorization = true,
    void Function(int, int)? onSendProgress,
  }) async {
    final Dio dio = Dio();
    dio.options = await _generateBaseOptions(authorization, urlApi, path);
    return dio.put<T>(path, data: data, onSendProgress: onSendProgress);
  }

  Future<Response<T>> get<T>({
    required String path,
    BaseUrlApi urlApi = BaseUrlApi.rick,
    bool authorization = true,
    Map<String, dynamic>? queryParameters,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) async {
    final Dio dio = Dio();
    dio.interceptors.add(SimpleCacheInterceptor());
    dio.options = await _generateBaseOptions(
      authorization,
      urlApi,
      path,
      connectTimeout,
      receiveTimeout,
    );
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<BaseOptions> _generateBaseOptions(
    bool authorization,
    BaseUrlApi baseUrlApi,
    String path, [
    Duration? connectTimeout,
    Duration? receiveTimeout,
  ]) async {
    return BaseOptions(
      connectTimeout: connectTimeout ?? const Duration(seconds: 60),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 60),
      headers: _getHeaders(authorization, baseUrlApi),
      baseUrl: _prepareBaseUrl(baseUrlApi, path),
    );
  }

  String _prepareBaseUrl(BaseUrlApi base, String path) {
    String? baseUrl = switch (base) {
      BaseUrlApi.rick => const String.fromEnvironment('API'),
      BaseUrlApi.labelary => '  http://api.labelary.com/v1',
    };

    return baseUrl;
  }

  Map<String, dynamic> _getHeaders(bool authorization, BaseUrlApi baseUrlApi) {
    final Map<String, dynamic> headers = <String, dynamic>{};
    if (baseUrlApi == BaseUrlApi.labelary) {
      headers['Accept'] = 'application/zpl';
    } else {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }
}
