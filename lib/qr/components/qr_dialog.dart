import 'dart:async';
import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/qr/model/qr_data_model.dart';
import 'package:cbhs/qr/provider/qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDialog extends ConsumerStatefulWidget {
  const QrDialog({super.key});

  @override
  ConsumerState<QrDialog> createState() => _QrDialogState();
}

class _QrDialogState extends ConsumerState<QrDialog> {
  Timer? _timer;
  int _seconds = 120;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _refreshQrCode();
    });
    _startTimer();
  }

  void _startTimer() {
    _seconds = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _timer?.cancel();
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshQrCode() async {
    ref.read(qrProvider.notifier).getQRdata();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final qrState = ref.watch(qrProvider);

    return AlertDialog(
      icon: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close)),
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: backgroundColor,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('입출입 QR 코드', style: AppTextStyles.subHeading()),
            if (qrState is QrDataModel)
              Expanded(
                child: Column(
                  children: [
                    _seconds > 0
                        ? QrImageView(
                            data: qrState.qrData,
                            size: 256.w,
                          )
                        : SizedBox(
                            width: 256.w,
                            height: 256.h,
                            child: Center(
                              child: OutlinedButton(
                                onPressed: _refreshQrCode,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: backgroundColor,
                                  backgroundColor: mainColor,
                                  side: const BorderSide(color: mainColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.refresh),
                                    const SizedBox(width: 10),
                                    Text('새로고침',
                                        style: AppTextStyles.regularSemiText()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    _seconds > 0
                        ? Text('유효시간 $_seconds초 남았습니다.',
                            style: AppTextStyles.basicText())
                        : Text('유효시간이 만료되었습니다.',
                            style: AppTextStyles.basicText()),
                  ],
                ),
              ),
            if (qrState is QrDataModelLoading)
              const Center(
                  child: SizedBox(
                      width: 256,
                      height: 256,
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ))),
            if (qrState is QrDataModelError) Text(qrState.message),
          ],
        ),
      ),
    );
  }
}
