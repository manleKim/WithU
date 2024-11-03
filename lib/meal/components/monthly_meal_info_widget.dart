import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/component_layout.dart';
import 'package:cbhs/meal/components/meal_type_selector_widget.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyMealInfoWidget extends StatefulWidget {
  final List<MealModel> mealList;
  const MonthlyMealInfoWidget({required this.mealList, super.key});

  @override
  State<MonthlyMealInfoWidget> createState() => _MonthlyMealInfoWidgetState();
}

class _MonthlyMealInfoWidgetState extends State<MonthlyMealInfoWidget> {
  late final DateTime sundayOfWeekBefore;
  late final DateTime saturdayOfWeekAfter;

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  String currentMealType = 'breakfast';

  @override
  void initState() {
    super.initState();
    setDateBoundary();
  }

  void setDateBoundary() async {
    final now = DateTime.now();

    // 이전 주 일요일 계산
    DateTime previousSunday = now.subtract(Duration(days: now.weekday % 7 + 7));
    sundayOfWeekBefore =
        DateTime(previousSunday.year, previousSunday.month, previousSunday.day);

    // 다음주 토요일 계산
    DateTime nextSaturday = now.add(Duration(days: 6 - now.weekday + 7));
    saturdayOfWeekAfter =
        DateTime(nextSaturday.year, nextSaturday.month, nextSaturday.day);
  }

  void _showMealsForSelectedDay(DateTime day) {
    List<MealModel> mealsForSelectedDay = widget.mealList.where((meal) {
      return isSameDay(meal.date, day);
    }).toList();

    MealModel currentMeal = mealsForSelectedDay.first;

    showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String mealValue = _getMealValue(currentMeal, currentMealType);
            return AlertDialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              title: Text(mealsForSelectedDay[0].fullDate),
              titleTextStyle: AppTextStyles.mainHeading(color: backgroundColor),
              content: ComponentLayout(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      MealTypeSelector(
                        currentMealType: currentMealType,
                        onMealTypeChanged: (mealType) {
                          setState(() {
                            currentMealType = mealType;
                            mealValue = _getMealValue(currentMeal, mealType);
                          });
                        },
                      ),
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getMealValue(MealModel meal, String mealType) {
    switch (mealType) {
      case 'breakfast':
        return meal.breakfast.join('\n');
      case 'lunch':
        return meal.lunch.join('\n');
      case 'dinner':
        return meal.dinner.join('\n');
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '캘린더로 자세히 보기',
          style: AppTextStyles.basicText(),
        ),
        const SizedBox(height: 12),
        ComponentLayout(
          child: TableCalendar(
            locale: 'ko_KR',
            focusedDay: focusedDay,
            firstDay: sundayOfWeekBefore,
            lastDay: saturdayOfWeekAfter,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                _showMealsForSelectedDay(selectedDay);
              });
            },
            selectedDayPredicate: (DateTime day) {
              return isSameDay(selectedDay, day);
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: selectedDay == DateTime.now()
                    ? mainColor
                    : const Color(0x8000AEBB), // Opacity 50%
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
