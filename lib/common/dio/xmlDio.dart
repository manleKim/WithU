import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final xmlDioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    XmlCustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class XmlCustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  XmlCustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    // if (options.headers['accessSession'] == 'true') {
    //   // 헤더 삭제
    //   options.headers.remove('accessSession');

    //   final session = await storage.read(key: ACCESS_SESSION_KEY);

    //   // 실제 토큰으로 대체
    //   options.headers.addAll({
    //     'Cookie': session,
    //   });
    // }

    options.headers.addAll({
      'Content-Type': 'text/xml',
    });

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    return handler.reject(err);
  }
}
