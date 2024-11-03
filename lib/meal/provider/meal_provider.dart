import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:cbhs/meal/repository/meal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final mealProvider =
    StateNotifierProvider<MealStateNotifier, MealModelBase>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return MealStateNotifier(repository: repository, storage: storage);
});

class MealStateNotifier extends StateNotifier<MealModelBase> {
  final MealRepository repository;
  final FlutterSecureStorage storage;

  MealStateNotifier({required this.repository, required this.storage})
      : super(MealModelLoading()) {
    getMeal();
  }

  void getMeal() async {
    try {
      final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);
      MealListModel resp;
      if (dormitoryNumber == "19-1049") {
        resp = await repository.getMeal(true);
      } else {
        resp = await repository.getMeal(false);
      }

      state = resp;
    } catch (e) {
      state = MealModelError(message: '식단 데이터를 가져오는데 실패했습니다.\n${e.toString()}');
    }
  }
}
