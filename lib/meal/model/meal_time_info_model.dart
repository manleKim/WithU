import 'package:cbhs/meal/model/meal_time_info_item_model.dart';

abstract class MealTimeModelBase {}

class MealTimeModelError extends MealTimeModelBase {
  final String message;

  MealTimeModelError({required this.message});
}

class MealTimeModelLoading extends MealTimeModelBase {}

class MealTimeInfoListModel extends MealTimeModelBase {
  final List<MealTimeInfoItem> mealTimeInfoList;

  MealTimeInfoListModel({required this.mealTimeInfoList});

  factory MealTimeInfoListModel.fromIsVacation(bool isVacation) {
    final DateTime current = DateTime.now();
    DateTime breakfastStart;
    DateTime breakfastEnd;
    DateTime lunchStart;
    DateTime lunchEnd;
    DateTime dinnerStart;
    DateTime dinnerEnd;

    if (isVacation) {
      breakfastStart =
          DateTime(current.year, current.month, current.day, 7, 30);
      breakfastEnd = DateTime(current.year, current.month, current.day, 8, 30);
      lunchStart = DateTime(current.year, current.month, current.day, 12, 0);
      lunchEnd = DateTime(current.year, current.month, current.day, 13, 0);
      dinnerStart = DateTime(current.year, current.month, current.day, 18, 0);
      dinnerEnd = DateTime(current.year, current.month, current.day, 19, 30);
    } else {
      breakfastStart = DateTime(current.year, current.month, current.day, 7, 0);
      breakfastEnd = DateTime(current.year, current.month, current.day, 8, 30);
      lunchStart = DateTime(current.year, current.month, current.day, 12, 0);
      lunchEnd = DateTime(current.year, current.month, current.day, 13, 0);
      dinnerStart = DateTime(current.year, current.month, current.day, 18, 0);
      dinnerEnd = DateTime(current.year, current.month, current.day, 20, 0);
    }

    return MealTimeInfoListModel(mealTimeInfoList: [
      MealTimeInfoItem(
          name: '조식',
          startAt: breakfastStart,
          endAt: breakfastEnd,
          isCurrent: current.isAfter(breakfastStart) &&
              current.isBefore(breakfastEnd)),
      MealTimeInfoItem(
          name: '중식',
          startAt: lunchStart,
          endAt: lunchEnd,
          isCurrent: current.isAfter(lunchStart) && current.isBefore(lunchEnd)),
      MealTimeInfoItem(
          name: '석식',
          startAt: dinnerStart,
          endAt: dinnerEnd,
          isCurrent:
              current.isAfter(dinnerStart) && current.isBefore(dinnerEnd)),
    ]);
  }
}
