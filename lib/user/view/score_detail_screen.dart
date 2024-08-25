import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/user/components/detail_card.dart';
import 'package:cbhs/user/model/score_model.dart';
import 'package:cbhs/user/provider/score_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoreDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'scoreDetail';

  const ScoreDetailScreen({super.key});

  @override
  ConsumerState<ScoreDetailScreen> createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends ConsumerState<ScoreDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(scoreProvider.notifier).getScoreDetailList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scoreProvider);

    // 완전 처음 로딩일때
    if (state is ScoreModelLoading) {
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
    if (state is ScoreModelError) {
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
                ref.read(scoreProvider.notifier).getScoreDetailList();
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
      appbar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: backgroundColor,
        title: const Text('상벌점 내역'),
        titleTextStyle: AppTextStyles.naviTitle(color: backgroundColor),
      ),
      child: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              if (state is ScoreModel) renderTop(state),
              if (state is ScoreModel)
                Expanded(
                  child: renderList(state),
                )
            ],
          )),
    );
  }

  ListView renderList(ScoreModel state) {
    return ListView.builder(
      itemCount: state.detailList.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.all(20),
        child: DetailCard(
            title: state.detailList[index].reason,
            date: state.detailList[index].createdAt,
            score: state.detailList[index].score),
      ),
    );
  }

  Container renderTop(ScoreModel state) {
    return Container(
      color: mainColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            const Icon(Icons.library_books_outlined, color: backgroundColor),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
              '누적 점수',
              style: AppTextStyles.subHeading(color: backgroundColor),
            )),
            Text('${state.detailList.fold<int>(0, (p, e) => p + e.score)}점',
                style: AppTextStyles.subHeading(color: backgroundColor)),
          ],
        ),
      ),
    );
  }
}
