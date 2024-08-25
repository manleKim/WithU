import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/util/data.dart';
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

  Future<void> getMe() async {
    final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);

    if (dormitoryNumber == null) {
      state = UserModelError(message: '로그아웃 후 이용하시길 바랍니다.');
      return;
    }
    final resp = await repository.getMe(getDormitoryFormatted(dormitoryNumber));

    state = resp;
  }

  // Future<UserModelBase> login({
  //   required String username,
  //   required String password,
  // }) async {
  //   try {
  //     state = UserModelLoading();

  //     final resp = await authRepository.login(
  //       username: username,
  //       password: password,
  //     );

  //     await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
  //     await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

  //     final userResp = await repository.getMe();

  //     state = userResp;

  //     return userResp;
  //   } catch (e) {
  //     state = UserModelError(message: '로그인에 실패했습니다.');

  //     return Future.value(state);
  //   }
  // }

  // Future<void> logout() async {
  //   state = null;

  //   await Future.wait(
  //     [
  //       storage.delete(key: REFRESH_TOKEN_KEY),
  //       storage.delete(key: ACCESS_TOKEN_KEY),
  //     ],
  //   );
  // }
}
