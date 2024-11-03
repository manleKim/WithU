import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/layout/padding_layout.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/overNight/view/over_night_detail_screen.dart';
import 'package:cbhs/user/components/my_dormitory_life_card.dart';
import 'package:cbhs/user/model/user_model.dart';
import 'package:cbhs/user/provider/user_me_provider.dart';
import 'package:cbhs/user/view/login_screen.dart';
import 'package:cbhs/user/view/reassess_detail_screen.dart';
import 'package:cbhs/user/view/score_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UserMeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'userMe';

  const UserMeScreen({super.key});

  @override
  ConsumerState<UserMeScreen> createState() => _UserMeScreenState();
}

class _UserMeScreenState extends ConsumerState<UserMeScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(userMeProvider.notifier).getMe();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    // 완전 처음 로딩일때
    if (state is UserModelLoading) {
      return const DefaultLayout(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          ),
        ),
      );
    }

    // 에러
    if (state is UserModelError) {
      return Center(
        child: PaddingLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: AppTextStyles.buttonText(),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  ref.read(userMeProvider.notifier).getMe();
                },
                child: Text(
                  '다시시도',
                  style: AppTextStyles.buttonText(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultLayout(
        child: SafeArea(
      top: true,
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            PaddingLayout(
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is UserModel) renderTop(user: state),
                  SizedBox(height: 30.h),
                  Text('나의 학사 생활', style: AppTextStyles.buttonText()),
                  SizedBox(height: 12.h),
                  if (state is UserModel)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ReassessDetailScreen()));
                      },
                      child: MyDormitoryLifeCard(
                        iconSvg: SvgPicture.asset(
                            'assets/svg/myRoom/my room_list.svg'),
                        title: '재사 요건 충족 여부',
                        reaseessList: state.reassessList,
                      ),
                    ),
                  SizedBox(height: 14.h),
                  if (state is UserModel)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ScoreDetailScreen()));
                      },
                      child: MyDormitoryLifeCard(
                          iconSvg: SvgPicture.asset(
                              'assets/svg/myRoom/my room_penalty_blue.svg'),
                          title: '상벌점 내역 차트',
                          score: state.rewordScore),
                    ),
                  SizedBox(height: 14.h),
                  if (state is UserModel)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const OverNightDetailScreen()));
                      },
                      child: MyDormitoryLifeCard(
                        iconSvg: SvgPicture.asset(
                            'assets/svg/myRoom/my room_calendar.svg'),
                        title: '외박 및 귀향 캘린더',
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 8,
              width: double.infinity,
              color: greyLightColor,
            ),
            PaddingLayout(
              top: 20,
              child: InkWell(
                onTap: () async {
                  await storage.deleteAll();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Text('로그아웃'),
                ),
              ),
            ),
            // PaddingLayout(
            //   top: 20,
            //   child: InkWell(
            //     onTap: () async {
            //       _showRecentOverNight(context);
            //     },
            //     child: const SizedBox(
            //       width: double.infinity,
            //       child: Text('테스트'),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    ));
  }
}

Row renderTop({required UserModel user}) {
  return Row(
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: greyMiddleColor),
        ),
        child: SvgPicture.asset(
          'assets/svg/myRoom/my room_logo.svg',
          fit: BoxFit.scaleDown,
        ),
      ),
      const SizedBox(width: 25),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(user.name, style: AppTextStyles.mainHeading()),
              const SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    user.isIn ? 'IN' : 'OUT',
                    style: AppTextStyles.regularText(color: backgroundColor),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                textStyle: AppTextStyles.regularText(color: backgroundColor),
                message:
                    "입퇴실 시간은 30분 단위로 업데이트 됩니다. 정보가 반영되지 않았다면 업데이트 전이니 잠시 기다려주세요.",
                child: const Icon(
                  Icons.info_outline,
                  color: greyMiddleColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset('assets/svg/myRoom/my room_home_semi black.svg'),
              const SizedBox(width: 5),
              Text(user.roomNum),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset('assets/svg/myRoom/my room_card.svg'),
              const SizedBox(width: 5),
              Text(user.dormitoryNumber),
            ],
          ),
        ],
      ),
    ],
  );
}
