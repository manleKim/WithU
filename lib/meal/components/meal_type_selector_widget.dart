import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealTypeSelector extends StatelessWidget {
  final String currentMealType;
  final Function(String) onMealTypeChanged;

  const MealTypeSelector({
    required this.currentMealType,
    required this.onMealTypeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMealButton('조식', 'breakfast'),
        SizedBox(width: 10.h),
        _buildMealButton('중식', 'lunch'),
        SizedBox(width: 10.h),
        _buildMealButton('석식', 'dinner'),
      ],
    );
  }

  Widget _buildMealButton(String label, String mealType) {
    final bool isSelected = mealType == currentMealType;
    return OutlinedButton(
      onPressed: () => onMealTypeChanged(mealType),
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 6),
        foregroundColor: isSelected ? backgroundColor : mainColor,
        backgroundColor: isSelected ? mainColor : backgroundColor,
        side: BorderSide(color: isSelected ? mainColor : backgroundColor),
      ),
      child: Text(
        label,
        style: AppTextStyles.regularText().copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? backgroundColor : mainColor),
      ),
    );
  }
}
