import 'package:cbhs/common/components/custom_text_form_field.dart';
import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/view/root_tab.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final String baseURL = (dotenv.env['LOGIN_URL'] as String);

                    final resp = await http.post(
                      Uri.parse('$baseURL/employee/loginProc.jsp'),
                      headers: {
                        'content-type': 'application/x-www-form-urlencoded',
                      },
                      body: 'USER_ID=$dormitoryNumber&USER_PW=$password',
                    );

                    if (resp.statusCode == 200) {
                      //로그인 오류
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('아이디와 비밀번호를 다시 입력해주세요')));
                      return;
                    }

                    await storage.write(
                        key: DORMITORY_NUMBER_KEY, value: dormitoryNumber);
                    await storage.write(key: PASSWORD_KEY, value: password);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RootTab()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: mainColor,
                  ),
                  child: const Text(
                    '로그인하기',
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
