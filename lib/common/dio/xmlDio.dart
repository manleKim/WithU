import 'dart:io';

import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final xmlDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
      // connectTimeout: const Duration(seconds: 6), // 6초 타임아웃 설정
      ));

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

    // 해외 IP 제한으로 인해 발생한 Timeout 에러일 경우 사용자에게 메시지를 표시
    if (err.type == DioExceptionType.connectionTimeout ||
        err.error is SocketException) {
      print('해외 IP에서는 이용할 수 없는 서비스입니다.');

      // 새로운 DioException을 생성하여 에러 메시지를 전달
      final newError = DioException(
        requestOptions: err.requestOptions,
        error:
            '해외 IP에서는 이용할 수 없는 서비스입니다.\n한국 IP인지 다시 한 번 확인해주세요.\n해외라면 무료 VPN 앱을 이용해 한국으로 설정하시고 이용해주시길바랍니다.',
        type: DioExceptionType.connectionTimeout,
      );
      return handler.reject(newError);
    }

    return handler.reject(err);
  }
}
