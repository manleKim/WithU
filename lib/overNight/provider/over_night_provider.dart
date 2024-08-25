import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/util/data.dart';
import 'package:cbhs/overNight/model/over_night_detail_model.dart';
import 'package:cbhs/overNight/repository/over_night_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final overNightProvider =
    StateNotifierProvider<OverNightStateNotifier, OverNightDetailModelBase>(
  (ref) {
    final overNightRepository = ref.watch(overNightRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return OverNightStateNotifier(
      repository: overNightRepository,
      storage: storage,
    );
  },
);

class OverNightStateNotifier extends StateNotifier<OverNightDetailModelBase> {
  final OverNightRepository repository;
  final FlutterSecureStorage storage;

  OverNightStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(OverNightDetailModelLoading()) {
    getOverNightDetailList();
  }

  Future<void> getOverNightDetailList() async {
    final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);

    if (dormitoryNumber == null) {
      state = OverNightDetailModelError(message: '로그아웃 후 다시 이용하시길 바랍니다.');
      return;
    }
    final resp = await repository
        .getOverNightDetailList(getDormitoryFormatted(dormitoryNumber));
    state = resp;
  }
}
