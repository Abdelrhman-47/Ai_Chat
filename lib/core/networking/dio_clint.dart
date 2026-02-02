import 'package:ai_chat/core/utils/sensetive.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://generativelanguage.googleapis.com/v1beta/models/',
      headers: {
        'x-goog-api-key': Sensetive.api_key,
        'Content-Type': 'application/json',
      },
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('➡️ Request to: ${options.uri}');
          print('Headers: ${options.headers}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response ${response.statusCode} from ${response.realUri}');
          print('Headers: ${response.headers}');
          return handler.next(response);
        },
        onError: (e, handler) {
          print('❌ Error: ${e.message}');
          print('Response: ${e.response}');
          return handler.next(e);
        },
      ),
    );
  }
  Dio get dio => _dio;
}
