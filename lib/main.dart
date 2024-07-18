import 'package:cbhs/common/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/config/.env');
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: CbhsApp()));
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
          debugShowCheckedModeBanner: false,
          title: 'WithU',
          // theme: appTheme,
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}

// final ThemeData appTheme = ThemeData(
//   fontFamily: 'Pretendard',
//   colorScheme: ColorScheme.fromSeed(seedColor: AppColor.main),
//   useMaterial3: true,
//   textTheme: const TextTheme(
//     headlineLarge: AppTextStyles.mainHeadingText,
//     headlineMedium: AppTextStyles.subHeadingTe,
//     labelLarge: AppTextStyles.buttonText,
//     bodyLarge: AppTextStyles.basicText,
//     bodyMedium: AppTextStyles.regularSemiText,
//     bodySmall: AppTextStyles.regularText,
//     labelMedium: AppTextStyles.detailedInfoText,
//     labelSmall: AppTextStyles.captionText,
//   ),
// );
