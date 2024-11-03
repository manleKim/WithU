import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/user/model/score_model.dart';
import 'package:cbhs/user/repository/score_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final scoreProvider = StateNotifierProvider<ScoreStateNotifier, ScoreModelBase>(
  (ref) {
    final scoreRepository = ref.watch(scoreRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return ScoreStateNotifier(
      repository: scoreRepository,
      storage: storage,
    );
  },
);

class ScoreStateNotifier extends StateNotifier<ScoreModelBase> {
  final ScoreRepository repository;
  final FlutterSecureStorage storage;

  ScoreStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(ScoreModelLoading()) {
    getScoreDetailList();
  }

  Future<void> getScoreDetailList() async {
    final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);

    if (dormitoryNumber == null) {
      state = ScoreModelError(message: '로그아웃 후 이용하시길 바랍니다.');
      return;
    }
    final resp = await repository.getScoreDetailList(dormitoryNumber);

    state = resp;
  }
}
