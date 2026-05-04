import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();
final cookieJar = CookieJar();

class ApiClient {
  final Dio dio;
  ApiClient._(this.dio);

  static Future<ApiClient> create() async {
    final baseUrl = dotenv.env['API_URL'];

    if (baseUrl == null) {
      throw Exception('API_URL não definida no .env');
    }
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://localhost:3100',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final dir = await getApplicationDocumentsDirectory();

    final cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookie'),
    );
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {}
          return handler.next(error);
        },
      ),
    );

    return ApiClient._(dio);
  }
}
