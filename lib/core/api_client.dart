import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ApiClient {
  ApiClient._(this._dio, this._cookieJar);

  final Dio _dio;
  final PersistCookieJar _cookieJar;

  static Future<ApiClient>? _instance;

  static Future<ApiClient> create() {
    return _instance ??= _create();
  }

  static Future<ApiClient> _create() async {
    final rawBaseUrl = _readBaseUrlFromEnv();
    final baseUri = Uri.tryParse(rawBaseUrl);

    if (rawBaseUrl.isEmpty ||
        baseUri == null ||
        !baseUri.hasScheme ||
        baseUri.host.isEmpty) {
      throw StateError('API_BASE_URL ausente ou inválida no .env');
    }

    final effectiveBaseUri = _normalizeBaseUri(baseUri);

    final supportDir = await getApplicationSupportDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage(p.join(supportDir.path, 'cookies')),
    );

    final dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUri.toString(),
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {Headers.acceptHeader: Headers.jsonContentType},
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(CookieManager(cookieJar));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await cookieJar.deleteAll();
          }
          handler.next(error);
        },
      ),
    );

    return ApiClient._(dio, cookieJar);
  }

  static Uri _normalizeBaseUri(Uri uri) {
    final isAndroidEmulator =
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        (uri.host == 'localhost' || uri.host == '127.0.0.1');

    if (!isAndroidEmulator) {
      return uri;
    }

    return uri.replace(host: '10.0.2.2');
  }

  static String _readBaseUrlFromEnv() {
    final value =
        dotenv.maybeGet('API_BASE_URL') ?? dotenv.maybeGet('API_BASEURL') ?? '';
    final trimmed = value.trim();

    if (trimmed.length >= 2) {
      final startsWithSingleQuote =
          trimmed.startsWith("'") && trimmed.endsWith("'");
      final startsWithDoubleQuote =
          trimmed.startsWith('"') && trimmed.endsWith('"');

      if (startsWithSingleQuote || startsWithDoubleQuote) {
        return trimmed.substring(1, trimmed.length - 1).trim();
      }
    }

    return trimmed;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<void> clearSession() => _cookieJar.deleteAll();

  void close({bool force = false}) => _dio.close(force: force);
}
