import 'package:cbhs/common/components/custom_text_form_field.dart';
import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/util/data.dart';
import 'package:cbhs/common/view/root_tab.dart';
import 'package:cbhs/user/xmls/xmls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xml/xml.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String dormitoryNumber = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: mainColor,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                ),
                SvgPicture.asset(
                  'assets/svg/logos/logo.svg',
                  width: MediaQuery.of(context).size.width / 2,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  hintText: '학사번호',
                  onChanged: (String value) {
                    dormitoryNumber = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: '비밀번호',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                OutlinedButton(
                  onPressed: () async {
                    if ((dormitoryNumber == dotenv.env['ADMIN_ID'] as String) &&
                        (password == dotenv.env['ADMIN_PASSWARD'] as String)) {
                      await storage.write(
                          key: DORMITORY_NUMBER_KEY, value: dormitoryNumber);
                      await storage.write(key: PASSWORD_KEY, value: password);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RootTab()));

                      return;
                    }

                    final String baseURL =
                        (dotenv.env['DORMITORY_URL'] as String);
                    final dio = Dio(BaseOptions(
                      connectTimeout: const Duration(seconds: 6), // 6초 타임아웃 설정
                    ));

                    final resp = await dio.post('$baseURL/cbhsLoginStd.do',
                        options: Options(
                          headers: {
                            'Content-Type': 'text/xml',
                          },
                        ),
                        data: loginXml(
                            dormitoryNumber, getPasswordFormatted(password)));

                    print(dormitoryNumber);
                    print(getPasswordFormatted(password));

                    if (resp.statusCode != 200) {
                      //네트워크 오류
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('네트워크 오류')));
                      return;
                    }
                    final document = XmlDocument.parse(resp.data);

                    // "CNT" 값이 0인 경우 실패로 간주
                    final cntElements = document.findAllElements('Col').where(
                        (element) => element.getAttribute('id') == 'CNT');
                    if (cntElements.isNotEmpty &&
                        cntElements.first.innerText == '0') {
                      // 실패 시 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('아이디와 비밀번호를 다시 입력해주세요')),
                      );
                      return;
                    }

                    await storage.write(
                        key: DORMITORY_NUMBER_KEY, value: dormitoryNumber);
                    await storage.write(key: PASSWORD_KEY, value: password);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RootTab()));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: mainColor,
                    backgroundColor: backgroundColor,
                    side: const BorderSide(color: backgroundColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    '로그인하기',
                    style: AppTextStyles.buttonText(color: mainColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
