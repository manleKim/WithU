import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final htmlDioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    HtmlCustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class HtmlCustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  HtmlCustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다 accessSession: true라는 값이 있다면
  // 실제 세션을 가져와서 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

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
