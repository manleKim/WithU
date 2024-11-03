import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/view/root_tab.dart';
import 'package:cbhs/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // deleteAutoLogin();
    checkAutoLogin();
  }

  void deleteAutoLogin() async {
    await storage.deleteAll();
  }

  void checkAutoLogin() async {
    final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);
    final password = await storage.read(key: PASSWORD_KEY);

    if (dormitoryNumber == null || password == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootTab()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: mainColor,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/logos/logo.svg',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16,
              ),
              const CircularProgressIndicator(
                color: backgroundColor,
              ),
            ],
          ),
        ));
  }
}
