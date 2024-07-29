import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/component_layout.dart';
import 'package:cbhs/meal/model/meal_time_info_model.dart';
import 'package:cbhs/meal/repository/meal_time_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MealTimeInfoWidget extends StatefulWidget {
  const MealTimeInfoWidget({super.key});

  @override
  State<MealTimeInfoWidget> createState() => _MealTimeInfoWidgetState();
}

class _MealTimeInfoWidgetState extends State<MealTimeInfoWidget> {
  bool isVacation = false;
  MealTimeInfoModel? mealTimeInfoModel;

  @override
  void initState() {
    super.initState();
    fetchMealTimes();
  }

  Future<void> fetchMealTimes() async {
    bool isVacationStatus = await getIsVacation();
    setState(() {
      isVacation = isVacationStatus;
      mealTimeInfoModel = getMealTimeInfoModel(isVacation);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mealTimeInfoModel == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: mainColor,
        ),
      );
    }
    return Column(
      children: [
        Text(
          '식사 시간 안내',
          style: AppTextStyles.basicText(),
        ),
        ComponentLayout(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMealTimeColumn('조식', mealTimeInfoModel!.breakfastStart,
                    mealTimeInfoModel!.breakfastEnd),
                _buildMealTimeColumn('중식', mealTimeInfoModel!.lunchStart,
                    mealTimeInfoModel!.lunchEnd),
                _buildMealTimeColumn('석식', mealTimeInfoModel!.dinnerStart,
                    mealTimeInfoModel!.dinnerEnd),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _buildMealTimeColumn(
      String mealName, String startTime, String endTime) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('HH:mm');
    DateTime start = DateTime(now.year, now.month, now.day).add(
      Duration(
        hours: format.parse(startTime).hour,
        minutes: format.parse(startTime).minute,
      ),
    );
    DateTime end = DateTime(now.year, now.month, now.day).add(
      Duration(
        hours: format.parse(endTime).hour,
        minutes: format.parse(endTime).minute,
      ),
    );
    final isCurrentTime = now.isAfter(start) && now.isBefore(end);
    final textStyle = isCurrentTime
        ? AppTextStyles.detailedInfoText()
            .copyWith(color: mainColor, fontWeight: FontWeight.w700)
        : AppTextStyles.detailedInfoText();

    return Column(
      children: [
        Text(mealName, style: textStyle),
        Text('$startTime ~ $endTime', style: textStyle),
      ],
    );
  }
}
