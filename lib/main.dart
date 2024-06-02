import 'package:cbhs/screens/main_screen.dart';
import 'package:cbhs/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const CbhsApp());
  FlutterNativeSplash.remove();
}

class CbhsApp extends StatelessWidget {
  const CbhsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'WithU',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.cyan),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const MainScreen(title: '메인 스크린'),
    );
  }
}
