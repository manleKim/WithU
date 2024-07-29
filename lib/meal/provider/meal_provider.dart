import 'package:cbhs/meal/model/meal_model.dart';
import 'package:cbhs/meal/repository/meal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealProvider =
    StateNotifierProvider<MealStateNotifier, MealModelBase>((ref) {
  final repository = ref.watch(mealRepositoryProvider);

  final notifer = MealStateNotifier(repository: repository);

  return notifer;
});

class MealStateNotifier extends StateNotifier<MealModelBase> {
  final MealRepository repository;

  MealStateNotifier({
    required this.repository,
  }) : super(MealModelLoading()) {
    getMeal();
  }

  void getMeal() async {
    final resp = await repository.getMeal();

    state = resp;
  }
}
