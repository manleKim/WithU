import 'package:cbhs/common/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle mainHeading({Color color = semiBlackColor}) => TextStyle(
      fontSize: 24.0.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle subHeading({Color color = semiBlackColor}) => TextStyle(
      fontSize: 20.0.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle naviTitle({Color color = semiBlackColor}) => TextStyle(
      fontSize: 18.0.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle buttonText({Color color = semiBlackColor}) => TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle basicText({Color color = semiBlackColor}) => TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle regularSemiText({Color color = semiBlackColor}) => TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle regularText({Color color = semiBlackColor}) => TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Pretendard',
      color: color);

  static TextStyle detailedInfoText({Color color = semiBlackColor}) =>
      TextStyle(
          fontSize: 12.0.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Pretendard',
          color: color);

  static TextStyle captionText({Color color = semiBlackColor}) => TextStyle(
      fontSize: 10.0.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Pretendard',
      color: color);
}
