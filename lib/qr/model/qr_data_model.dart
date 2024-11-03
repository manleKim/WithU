abstract class QrDataModelBase {}

class QrDataModelError extends QrDataModelBase {
  final String message;

  QrDataModelError({
    required this.message,
  });
}

class QrDataModelLoading extends QrDataModelBase {}

class QrDataModel extends QrDataModelBase {
  final String qrData;

  QrDataModel({required this.qrData});

  factory QrDataModel.fromHtml(String html) {
    //Html 코드에서 qr 데이터를 추출
    final RegExp regex = RegExp(r"makeCode\('(\d+)'\)");
    final match = regex.firstMatch(html);
    final qrData = match!.group(1);
    return QrDataModel(qrData: qrData!);
  }
}
