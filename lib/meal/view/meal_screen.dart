import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/meal/components/meal_time_info_widget.dart';
import 'package:cbhs/meal/components/monthly_meal_info_widget.dart';
import 'package:cbhs/meal/components/weekly_meal_info_widget.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:cbhs/meal/provider/meal_provider.dart';
import 'package:flutter/material.dart';
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
    ref.read(mealProvider.notifier).getMeal();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealProvider);

    // 완전 처음 로딩일때
    if (state is MealModelLoading) {
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
    if (state is MealModelError) {
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
                ref.read(mealProvider.notifier).getMeal();
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
      child: CustomScrollView(
        controller: controller,
        slivers: [
          const SliverToBoxAdapter(child: MealTimeInfoWidget()),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          if (state is MealListModel)
            SliverToBoxAdapter(
                child: WeeklyMealInfoWidget(mealList: state.mealList)),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          if (state is MealListModel)
            SliverToBoxAdapter(
                child: MonthlyMealInfoWidget(mealList: state.mealList)),
        ],
      ),
    ));
  }
}
