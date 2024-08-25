import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/layout/padding_layout.dart';
import 'package:cbhs/overNight/view/over_night_detail_screen.dart';
import 'package:cbhs/user/components/my_dormitory_life_card.dart';
import 'package:cbhs/user/model/user_model.dart';
import 'package:cbhs/user/provider/user_me_provider.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                ref.read(userMeProvider.notifier).getMe();
              },
              child: const Text(
                '다시시도',
              ),
            ),
          ],
        ),
      );
    }

    return DefaultLayout(
        child: SafeArea(
      top: true,
      bottom: false,
      child: PaddingLayout(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            if (state is UserModel) renderTop(user: state),
            SliverToBoxAdapter(child: SizedBox(height: 30.h)),
            SliverToBoxAdapter(
                child: Text('나의 학사 생활', style: AppTextStyles.buttonText())),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            if (state is UserModel)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ReassessDetailScreen()));
                  },
                  child: MyDormitoryLifeCard(
                    iconSvg: const Icon(Icons.format_list_numbered_rounded,
                        color: mainColor),
                    title: '재사 요건 충족 여부',
                    reaseessList: state.reassessList,
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 14.h)),
            if (state is UserModel)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ScoreDetailScreen()));
                  },
                  child: MyDormitoryLifeCard(
                      iconSvg:
                          const Icon(Icons.book_outlined, color: mainColor),
                      title: '상벌점 내역 차트',
                      score: state.rewordScore),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 14.h)),
            if (state is UserModel)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OverNightDetailScreen()));
                  },
                  child: const MyDormitoryLifeCard(
                    iconSvg: Icon(Icons.calendar_month, color: mainColor),
                    title: '외박 및 귀향 캘린더',
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}

SliverToBoxAdapter renderTop({required UserModel user}) {
  return SliverToBoxAdapter(
    child: Row(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: grayMiddleColor),
          ),
        ),
        const SizedBox(width: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(user.name, style: AppTextStyles.mainHeading()),
                const SizedBox(width: 10),
                Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        user.isIn ? 'IN' : 'OUT',
                        style:
                            AppTextStyles.regularText(color: backgroundColor),
                      ),
                    ))
              ],
            ),
            Row(
              children: [
                const Icon(Icons.home_outlined),
                const SizedBox(width: 5),
                Text(user.roomNum),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.credit_card_rounded),
                const SizedBox(width: 5),
                Text(user.dormitoryNumber),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
