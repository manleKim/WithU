import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/layout/padding_layout.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/common/util/data.dart';
import 'package:cbhs/overNight/provider/over_night_provider.dart';
import 'package:cbhs/overNight/view/over_night_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OverNightDoneScreen extends ConsumerStatefulWidget {
  final int period;
  final DateTime startDate;
  final DateTime endDate;
  final String reasonType;
  final String reasonDetail;
  final String destinationState;
  final String destinationCity;
  final String type;

  static String get routeName => 'overNightDone';

  const OverNightDoneScreen({
    super.key,
    required this.period,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reasonType,
    required this.reasonDetail,
    required this.destinationState,
    required this.destinationCity,
  });

  @override
  ConsumerState<OverNightDoneScreen> createState() =>
      _OverNightDoneScreenState();
}

class _OverNightDoneScreenState extends ConsumerState<OverNightDoneScreen> {
  late Future<bool> _postOverNightFuture;

  @override
  void initState() {
    super.initState();
    _postOverNightFuture = _postOverNight();
  }

  Future<bool> _postOverNight() async {
    return await ref.read(overNightProvider.notifier).postOverNight(
          type: widget.type,
          startDate: getDateStringFormatted(widget.startDate),
          endDate: getDateStringFormatted(widget.endDate),
          reasonType: widget.reasonType,
          reasonDetail: widget.reasonDetail,
          destinationState: widget.destinationState,
          destinationCity: widget.destinationCity,
        );
  }

  Future<void> _saveData() async {
    await storage.write(key: PERIOD_KEY, value: widget.period.toString());
    await storage.write(key: REASONTYPE_KEY, value: widget.reasonType);
    await storage.write(key: REASONDETAIL_KEY, value: widget.reasonDetail);
    await storage.write(
        key: DESTINATIONSTATE_KEY, value: widget.destinationState);
    await storage.write(
        key: DESTINATIONCITY_KEY, value: widget.destinationCity);
    await storage.write(
        key: DESTINATIONCITY_KEY, value: widget.destinationCity);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: FutureBuilder<bool>(
          future: _postOverNightFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: mainColor),
                  Text(
                      '${widget.type == 'overNight' ? '외박' : '귀향'} 신청 중입니다......',
                      style: AppTextStyles.subHeading()),
                ],
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              // 성공
              if (widget.type == 'overNight') {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await _saveData();
                });
              }
              return PaddingLayout(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: mainColor, size: 100),
                          const SizedBox(height: 20),
                          Text(
                              '${widget.type == 'overNight' ? '외박' : '귀향'} 신청이 완료되었어요!',
                              style: AppTextStyles.subHeading()),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: backgroundColor,
                                backgroundColor: greyStrongColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('돌아가기',
                                style: AppTextStyles.buttonText(
                                    color: backgroundColor)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: backgroundColor,
                                backgroundColor: mainColor),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const OverNightDetailScreen()));
                            },
                            child: Text('신청내역 보기',
                                style: AppTextStyles.buttonText(
                                    color: backgroundColor)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return PaddingLayout(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.red, size: 100),
                          const SizedBox(height: 20),
                          Text(
                              '네트워크 오류 혹은 해외 IP 사용으로 인해\n신청에 실패했어요!\n\n네트워크 상태와 국내 IP인지를 확인하고\n해외라면 무료 VPN 앱을 이용해 한국으로 설정하시고 이용해주시길바랍니다.',
                              style: AppTextStyles.subHeading(),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: backgroundColor,
                          backgroundColor: Colors.red),
                      child: Text('돌아가기',
                          style:
                              AppTextStyles.buttonText(color: backgroundColor)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
