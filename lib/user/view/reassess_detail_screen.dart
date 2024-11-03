import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/user/components/detail_card.dart';
import 'package:cbhs/user/model/reassess_model.dart';
import 'package:cbhs/user/provider/reassess_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReassessDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'scoreDetail';

  const ReassessDetailScreen({super.key});

  @override
  ConsumerState<ReassessDetailScreen> createState() =>
      _ReassessDetailScreenState();
}

class _ReassessDetailScreenState extends ConsumerState<ReassessDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(reassessProvider.notifier).getReassessDetailList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reassessProvider);

    // 완전 처음 로딩일때
    if (state is ReassessModelLoading) {
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
    if (state is ReassessModelError) {
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
                ref.read(reassessProvider.notifier).getReassessDetailList();
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
        title: const Text('재사 요건 충족 여부'),
        titleTextStyle: AppTextStyles.naviTitle(color: backgroundColor),
      ),
      child: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              if (state is ReassessModel) renderTop(state),
              if (state is ReassessModel)
                Expanded(
                  child: renderList(state),
                )
            ],
          )),
    );
  }

  ListView renderList(ReassessModel state) {
    return ListView.builder(
      itemCount: state.detailList.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.all(20),
        child: DetailCard(
            title: state.detailList[index].title,
            date: state.detailList[index].createdAt,
            type: state.detailList[index].reassessType),
      ),
    );
  }

  Container renderTop(ReassessModel state) {
    return Container(
      color: mainColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              renderReassessItem(model: state.reassessList[0]),
              const VerticalDivider(width: 1, color: backgroundColor),
              renderReassessItem(model: state.reassessList[1]),
              const VerticalDivider(width: 1, color: backgroundColor),
              renderReassessItem(model: state.reassessList[2]),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox renderReassessItem({required ReassessElementModel model}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Column(
        children: [
          Text(
            model.name,
            style: AppTextStyles.regularText(color: backgroundColor),
          ),
          Text('${model.count}/${model.satisfiedCount}',
              style: AppTextStyles.subHeading(color: backgroundColor)),
        ],
      ),
    );
  }
}
