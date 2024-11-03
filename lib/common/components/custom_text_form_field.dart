import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: backgroundColor,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: backgroundColor,
      // 비밀번호 입력할때
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      style: AppTextStyles.basicText(color: backgroundColor),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: AppTextStyles.basicText(color: backgroundColor),
        fillColor: mainColor,
        // false - 배경색 없음
        // true - 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: backgroundColor,
          ),
        ),
      ),
    );
  }
}
