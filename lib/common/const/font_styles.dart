import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle mainHeading() => TextStyle(
      fontSize: 24.0.sp, fontWeight: FontWeight.bold, fontFamily: 'Pretendard');

  static TextStyle subHeading() => TextStyle(
      fontSize: 20.0.sp, fontWeight: FontWeight.w600, fontFamily: 'Pretendard');

  static TextStyle buttonText() => TextStyle(
      fontSize: 16.0.sp, fontWeight: FontWeight.w600, fontFamily: 'Pretendard');

  static TextStyle basicText() => TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.normal,
      fontFamily: 'Pretendard');

  static TextStyle regularSemiText() => TextStyle(
      fontSize: 14.0.sp, fontWeight: FontWeight.w600, fontFamily: 'Pretendard');

  static TextStyle regularText() => TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.normal,
      fontFamily: 'Pretendard');

  static TextStyle detailedInfoText() => TextStyle(
      fontSize: 12.0.sp,
      fontWeight: FontWeight.normal,
      fontFamily: 'Pretendard');

  static TextStyle captionText() => TextStyle(
      fontSize: 10.0.sp,
      fontWeight: FontWeight.normal,
      fontFamily: 'Pretendard');
}
