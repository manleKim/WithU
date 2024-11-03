import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/common/layout/padding_layout.dart';
import 'package:cbhs/meal/components/meal_time_info_widget.dart';
import 'package:cbhs/meal/components/monthly_meal_info_widget.dart';
import 'package:cbhs/meal/components/weekly_meal_info_widget.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:cbhs/meal/model/meal_time_info_model.dart';
import 'package:cbhs/meal/provider/meal_provider.dart';
import 'package:cbhs/meal/provider/meal_time_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealScreen extends ConsumerStatefulWidget {
  static String get routeName => 'meal';

  const MealScreen({super.key});

  @override
  ConsumerState<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends ConsumerState<MealScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(mealTimeProvider.notifier).getMealTimeInfoModel();
    ref.read(mealProvider.notifier).getMeal();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: mainColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealProvider);
    final timeState = ref.watch(mealTimeProvider);

    // 완전 처음 로딩일때
    if (state is MealModelLoading || timeState is MealTimeModelLoading) {
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
    if (state is MealModelError || timeState is MealTimeModelError) {
      return Center(
        child: PaddingLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is MealModelError)
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.buttonText(),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (state is MealModelError) {
                    ref.read(mealProvider.notifier).getMeal();
                  }
                  if (state is MealTimeModelError) {
                    ref.read(mealTimeProvider.notifier).getMealTimeInfoModel();
                  }
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
        appbar: AppBar(
          title: const Text('식사 시간 안내'),
          titleSpacing: 20,
          titleTextStyle: AppTextStyles.naviTitle(color: backgroundColor),
          automaticallyImplyLeading: false,
          backgroundColor: mainColor,
          foregroundColor: backgroundColor,
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Tooltip(
                message:
                    '간편식 - 06:00 ~ 07:00 (방학 06:30 ~ 07:30)\n조식 - 07:00 ~ 08:30 (방학 07:30 ~ 08:30)\n중식 - 12:00 ~ 13:00 (방학 동일)\n석식 - 18:00 ~ 20:00 (방학 18:00 ~ 19:30)',
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(
                  Icons.info_outline,
                  size: 24.w,
                ),
              ),
            ),
          ],
        ),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              if (timeState is MealTimeInfoListModel)
                renderMealTimeInfo(model: timeState),
              const SizedBox(height: 20),
              Expanded(
                child: PaddingLayout(
                  child: CustomScrollView(
                    controller: controller,
                    slivers: [
                      if (state is MealListModel)
                        SliverToBoxAdapter(
                          child: WeeklyMealInfoWidget(mealList: state.mealList),
                        ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 25),
                      ),
                      if (state is MealListModel)
                        SliverToBoxAdapter(
                          child:
                              MonthlyMealInfoWidget(mealList: state.mealList),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Container renderMealTimeInfo({required MealTimeInfoListModel model}) {
  return Container(
    color: mainColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MealTimeInfoWidget(item: model.mealTimeInfoList[0]),
          MealTimeInfoWidget(item: model.mealTimeInfoList[1]),
          MealTimeInfoWidget(item: model.mealTimeInfoList[2]),
        ],
      ),
    ),
  );
}
