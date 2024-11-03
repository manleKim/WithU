import 'package:cbhs/meal/model/meal_time_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('isVacation')
        .doc('isVacation')
        .get();

    return MealTimeInfoListModel.fromIsVacation(doc['isVacation']);
  }
}
