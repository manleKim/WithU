import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/util/data.dart';
import 'package:cbhs/user/model/reassess_model.dart';
import 'package:cbhs/user/repository/reassess_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final reassessProvider =
    StateNotifierProvider<ReassessStateNotifier, ReassessModelBase>(
  (ref) {
    final reassessRepository = ref.watch(reassessRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return ReassessStateNotifier(
      repository: reassessRepository,
      storage: storage,
    );
  },
);

class ReassessStateNotifier extends StateNotifier<ReassessModelBase> {
  final ReassessRepository repository;
  final FlutterSecureStorage storage;

  ReassessStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(ReassessModelLoading()) {
    getReassessDetailList();
  }

  Future<void> getReassessDetailList() async {
    final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);

    if (dormitoryNumber == null) {
      state = ReassessModelError(message: '로그아웃 후 이용하시길 바랍니다.');
      return;
    }
    final resp = await repository
        .getReassessDetailList(getDormitoryFormatted(dormitoryNumber));

    state = resp;
  }
}
