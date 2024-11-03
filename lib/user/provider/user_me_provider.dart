import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/user/model/user_model.dart';
import 'package:cbhs/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase>(
  (ref) {
    final userMeRepository = ref.watch(userMeRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return UserMeStateNotifier(
      repository: userMeRepository,
      storage: storage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase> {
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기
    getMe();
  }

  void getMe() async {
    final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);

    if (dormitoryNumber == null) {
      state = UserModelError(message: '로그아웃 후 이용하시길 바랍니다.');
      return;
    }

    try {
      final resp = await repository.getMe(dormitoryNumber);
      state = resp;
    } catch (e) {
      state = UserModelError(message: '유저 데이터를 가져오는데 실패했습니다.\n${e.toString()}');
    }
  }
}
