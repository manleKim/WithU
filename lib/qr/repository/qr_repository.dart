import 'package:cbhs/qr/model/qr_data_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final qrRepositoryProvider = Provider<QrRepository>(
  (ref) {
    final repository = QrRepository(baseUrl: dotenv.env['LOGIN_URL'] as String);

    return repository;
  },
);

class QrRepository {
  final String baseUrl;

  QrRepository({required this.baseUrl});

  Future<QrDataModel> getQRdata(
      {required String dormitoryNumber, required String password}) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/employee/loginProc.jsp'),
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
      },
      body: 'USER_ID=$dormitoryNumber&USER_PW=$password',
    );

    if (resp.statusCode != 302) {
      //로그인 오류
      print(resp.statusCode);
      throw Exception('QR 데이터를 가져오지 못했습니다.');
    }

    //redirect 처리
    final location = resp.headers['location'];
    final cookies = parseCookies(resp.headers['set-cookie']!);
    final result = await redirectGetReuest(location!, cookies);

    return QrDataModel.fromHtml(result);
  }

  Map<String, String> parseCookies(String cookiesString) {
    //필요한 쿠키만 추출
    final cookies = <String, String>{};

    cookiesString.split(',').forEach((cookie) {
      final keyValue = cookie.trim().split(';')[0].split('=');
      if (keyValue.length == 2) {
        cookies[keyValue[0]] = keyValue[1];
      }
    });

    return cookies;
  }

  Future<String> redirectGetReuest(
      String location, Map<String, String> cookies) async {
    //헤더에 필요한 쿠키를 담아서 요청
    final headers = {
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    };

    final response = await http.get(
      Uri.parse('$baseUrl$location'),
      headers: headers,
    );
    return response.body;
  }
}
