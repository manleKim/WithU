import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/component_layout.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/layout/padding_layout.dart';
import 'package:cbhs/home/view/components/recent_over_night_widget.dart';
import 'package:cbhs/home/view/components/reward_penalty_graph.dart';
import 'package:cbhs/home/view/web_view_screen.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:cbhs/meal/provider/meal_provider.dart';
import 'package:cbhs/user/model/user_model.dart';
import 'package:cbhs/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'home';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(userMeProvider.notifier).getMe();
    ref.read(mealProvider.notifier).getMeal();
  }

  @override
  Widget build(BuildContext context) {
    final mealState = ref.watch(mealProvider);
    final scoreState = ref.watch(userMeProvider);

    // 완전 처음 로딩일때
    if (mealState is MealModelLoading || scoreState is UserModelLoading) {
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
    if (mealState is MealModelError && scoreState is UserModelError) {
      return Center(
        child: PaddingLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "해외 IP에서는 이용할 수 없는 서비스입니다.\n한국 IP인지 다시 한 번 확인해주세요.\n해외라면 무료 VPN 앱을 이용해 한국으로 설정하시고 이용해주시길바랍니다.",
                textAlign: TextAlign.center,
                style: AppTextStyles.buttonText(),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  ref.read(mealProvider.notifier).getMeal();
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
    if (mealState is MealListModel && scoreState is UserModel) {
      return DefaultLayout(
          child: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
            child: PaddingLayout(
          top: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              ComponentLayout(
                radius: 15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘의 식단',
                        style: AppTextStyles.regularText(color: mainColor),
                      ),
                      const SizedBox(height: 15),
                      _buildMeal(mealList: mealState.mealList),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ComponentLayout(
                radius: 15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '커스텀 외박',
                        style: AppTextStyles.regularText(color: mainColor),
                      ),
                      const SizedBox(height: 15),
                      const RecentOverNightInfo(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ComponentLayout(
                radius: 15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상벌점 누계',
                        style: AppTextStyles.regularText(color: mainColor),
                      ),
                      const SizedBox(height: 5),
                      Text('${scoreState.rewordScore}점',
                          style: AppTextStyles.subHeading()),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: RewardPenaltyGraph(
                            points: int.parse(scoreState.rewordScore)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          '로딩 중입니다.\n계속 로딩이 지속된다면 네트워크가 불안정하거나 오류가 발생한 것이니 앱을 종료한 후 다시 실행해주시길 바랍니다.',
          style: AppTextStyles.regularSemiText(),
        ),
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      children: [
        Expanded(
            child: SvgPicture.asset(
          'assets/svg/main/main_logo.svg',
          alignment: Alignment.centerLeft,
        )),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebViewScreen(),
                ),
              );
            },
            child: SvgPicture.asset('assets/svg/main/main_globe.svg')),
      ],
    );
  }

  Column _buildMeal({required List<MealModel> mealList}) {
    final today = DateTime.now();
    int idx = 0;
    for (int i = 0; i < mealList.length; i++) {
      if (mealList[i].date.year == today.year &&
          mealList[i].date.month == today.month &&
          mealList[i].date.day == today.day) {
        idx = i;
        break;
      }
    }
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: greyStrongColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: Text('조식',
                    style: AppTextStyles.regularText(color: backgroundColor)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
              mealList[idx].breakfast.join(' '),
              style: AppTextStyles.detailedInfoText(),
            )),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: greyStrongColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: Text('중식',
                    style: AppTextStyles.regularText(color: backgroundColor)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
              mealList[idx].lunch.join(' '),
              style: AppTextStyles.detailedInfoText(),
            )),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: greyStrongColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: Text('석식',
                    style: AppTextStyles.regularText(color: backgroundColor)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
              mealList[idx].dinner.join(' '),
              style: AppTextStyles.detailedInfoText(),
            )),
          ],
        ),
      ],
    );
  }
}
