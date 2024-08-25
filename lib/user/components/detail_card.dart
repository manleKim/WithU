import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/user/model/score_model.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String date;
  final int? score;
  final String? type;

  const DetailCard(
      {required this.title,
      required this.date,
      this.score,
      this.type,
      super.key});

  factory DetailCard.fromScoreModel({required ScoreDetail scoreDetail}) {
    return DetailCard(
        title: scoreDetail.reason,
        date: scoreDetail.createdAt,
        score: scoreDetail.score);
  }

  // factory DetailCard.fromReassessModel({required Reass scoreDetail}){
  //   return DetailCard(title: scoreDetail.reason, date: scoreDetail.createdAt, score: scoreDetail.score);
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.regularText()),
              Text(date,
                  style:
                      AppTextStyles.detailedInfoText(color: grayMiddleColor)),
            ],
          ),
        ),
        if (score != null)
          Text('${score! > 0 ? '+' : ''}$score점',
              style: AppTextStyles.buttonText(
                  color: score! >= 0 ? mainColor : Colors.red)),
        if (type != null)
          Text(type!, style: AppTextStyles.buttonText(color: mainColor))
      ],
    );
  }
}
