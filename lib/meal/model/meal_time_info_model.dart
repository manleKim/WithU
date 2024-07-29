class MealTimeInfoModel {
  final String breakfastStart,
      breakfastEnd,
      lunchStart,
      lunchEnd,
      dinnerStart,
      dinnerEnd;

  MealTimeInfoModel({
    required this.breakfastStart,
    required this.breakfastEnd,
    required this.lunchStart,
    required this.lunchEnd,
    required this.dinnerStart,
    required this.dinnerEnd,
  });
}

MealTimeInfoModel getMealTimeInfoModel(bool isVacation) {
  if (isVacation) {
    return MealTimeInfoModel(
      breakfastStart: '07:30',
      breakfastEnd: '08:30',
      lunchStart: '12:00',
      lunchEnd: '13:00',
      dinnerStart: '18:00',
      dinnerEnd: '19:30',
    );
  } else {
    return MealTimeInfoModel(
      breakfastStart: '07:00',
      breakfastEnd: '08:30',
      lunchStart: '12:00',
      lunchEnd: '13:00',
      dinnerStart: '18:00',
      dinnerEnd: '20:00',
    );
  }
}
