import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/component_layout.dart';
import 'package:cbhs/user/model/reassess_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyDormitoryLifeCard extends StatelessWidget {
  //final SvgPicture iconSvg;
  final Icon iconSvg;
  final String title;
  final String? score;
  final List<ReassessElementModel>? reaseessList;
  const MyDormitoryLifeCard(
      {required this.iconSvg,
      required this.title,
      this.score,
      this.reaseessList,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentLayout(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.5, vertical: 16.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              iconSvg,
              const SizedBox(width: 4),
              Expanded(
                  child: Text(
                title,
                style: AppTextStyles.regularText(color: mainColor),
              )),
              if (score != null)
                Text('${score!}점', style: AppTextStyles.subHeading()),
              const Icon(Icons.keyboard_arrow_right_rounded),
            ],
          ),
          if (reaseessList != null) const SizedBox(height: 14),
          if (reaseessList != null)
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  renderReassessItem(context, model: reaseessList![0]),
                  const VerticalDivider(width: 1, color: grayMiddleColor),
                  renderReassessItem(context, model: reaseessList![1]),
                  const VerticalDivider(width: 1, color: grayMiddleColor),
                  renderReassessItem(context, model: reaseessList![2]),
                ],
              ),
            ),
        ],
      ),
    ));
  }

  SizedBox renderReassessItem(BuildContext context,
      {required ReassessElementModel model}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Column(
        children: [
          Text(
            model.name,
            style: AppTextStyles.regularText(color: grayMiddleColor),
          ),
          Text('${model.count}/${model.satisfiedCount}',
              style: AppTextStyles.subHeading()),
        ],
      ),
    );
  }
}
