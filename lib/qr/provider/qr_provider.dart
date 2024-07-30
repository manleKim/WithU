import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/qr/model/qr_data_model.dart';
import 'package:cbhs/qr/repository/qr_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final qrProvider =
    StateNotifierProvider<QrStateNotifier, QrDataModelBase>((ref) {
  final repository = ref.watch(qrRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  final notifer = QrStateNotifier(repository: repository, storage: storage);

  return notifer;
});

class QrStateNotifier extends StateNotifier<QrDataModelBase> {
  final QrRepository repository;
  final FlutterSecureStorage storage;

  QrStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(QrDataModelLoading()) {
    getQRdata();
  }

  Future<void> getQRdata() async {
    state = QrDataModelLoading();
    try {
      final dormitoryNumber = await storage.read(key: DORMITORY_NUMBER_KEY);
      final password = await storage.read(key: PASSWORD_KEY);

      if (dormitoryNumber == null || password == null) {
        state = QrDataModelError(message: '학사번호와 생년월일이 잘못되었습니다.');
        return;
      }

      final resp = await repository.getQRdata(
          dormitoryNumber: dormitoryNumber, password: password);

      state = resp;
      print(resp.qrData);
    } catch (e) {
      state = QrDataModelError(
          message: '입출입 QR 데이터를 가져오는데 실패했습니다.\n${e.toString()}');
    }
  }
}
