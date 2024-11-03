import 'package:cbhs/meal/model/meal_time_info_model.dart';
import 'package:cbhs/meal/repository/meal_time_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealTimeProvider =
    StateNotifierProvider<MealTimeStateNotifier, MealTimeModelBase>((ref) {
  final repository = ref.watch(mealTimeRepositoryProvider);

  final notifer = MealTimeStateNotifier(repository: repository);

  return notifer;
});

class MealTimeStateNotifier extends StateNotifier<MealTimeModelBase> {
  final MealTimeRepository repository;

  MealTimeStateNotifier({
    required this.repository,
  }) : super(MealTimeModelLoading()) {
    getMealTimeInfoModel();
  }

  void getMealTimeInfoModel() async {
    try {
      final resp = await repository.getMealTimeInfoModel();
      state = resp;
    } catch (e) {
      state = MealTimeModelError(
          message: '식사 시간 데이터를 가져오는데 실패했습니다.\n${e.toString()}');
    }
  }
}
