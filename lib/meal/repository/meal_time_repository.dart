import 'package:cbhs/meal/model/meal_time_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealTimeRepositoryProvider = Provider<MealTimeRepository>(
  (ref) {
    final repository = MealTimeRepository();

    return repository;
  },
);

class MealTimeRepository {
  MealTimeRepository();

  Future<MealTimeInfoListModel> getMealTimeInfoModel() async {
    return MealTimeInfoListModel.fromIsVacation(false);
  }
}
