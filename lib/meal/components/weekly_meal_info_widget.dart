import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/component_layout.dart';
import 'package:cbhs/meal/components/meal_type_selector_widget.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyMealInfoWidget extends StatefulWidget {
  final List<MealModel> mealList;
  const WeeklyMealInfoWidget({required this.mealList, super.key});

  @override
  State<WeeklyMealInfoWidget> createState() => _WeeklyMealInfoWidgetState();
}

class _WeeklyMealInfoWidgetState extends State<WeeklyMealInfoWidget> {
  int currentIdx = 0;
  String currentMealType = 'breakfast';

  @override
  void initState() {
    super.initState();
    setCurrentIdx();
  }

  void setCurrentIdx() {
    final today = DateTime.now();
    for (int i = 0; i < widget.mealList.length; i++) {
      if (widget.mealList[i].date.year == today.year &&
          widget.mealList[i].date.month == today.month &&
          widget.mealList[i].date.day == today.day) {
        currentIdx = i;
        break;
      }
    }
  }

  void _showPreviousMeal() {
    setState(() {
      if (currentIdx > 0) {
        currentIdx--;
      }
    });
  }

  void _showNextMeal() {
    setState(() {
      if (currentIdx < widget.mealList.length - 1) {
        currentIdx++;
      }
    });
  }

  void _setMealType(String mealType) {
    setState(() {
      currentMealType = mealType;
    });
  }

  @override
  Widget build(BuildContext context) {
    MealModel currentMeal = widget.mealList[currentIdx];
    String mealValue;
    switch (currentMealType) {
      case 'breakfast':
        mealValue = currentMeal.breakfast.join('\n');
        break;
      case 'lunch':
        mealValue = currentMeal.lunch.join('\n');
        break;
      case 'dinner':
        mealValue = currentMeal.dinner.join('\n');
        break;
      default:
        mealValue = '';
    }
    return ComponentLayout(
      height: 270.h,
      child: Column(
        children: [
          MealNavigationRow(
              currentMeal: currentMeal,
              onPrevious: _showPreviousMeal,
              onNext: _showNextMeal),
          MealTypeSelector(
              currentMealType: currentMealType,
              onMealTypeChanged: _setMealType),
          Expanded(
            child: Center(
              child: Text(
                mealValue,
                style: AppTextStyles.regularText(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MealNavigationRow extends StatelessWidget {
  final MealModel currentMeal;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MealNavigationRow({
    required this.currentMeal,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          color: mainColor,
          onPressed: onPrevious,
        ),
        Text(
          currentMeal.fullDate,
          style: AppTextStyles.basicText()
              .copyWith(color: mainColor, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: mainColor,
          onPressed: onNext,
        ),
      ],
    );
  }
}
