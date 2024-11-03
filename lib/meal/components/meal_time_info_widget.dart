import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/meal/model/meal_time_info_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MealTimeInfoWidget extends StatelessWidget {
  final MealTimeInfoItem item;
  const MealTimeInfoWidget({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: item.isCurrent ? backgroundColor : mainColor))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        child: Column(
          children: [
            Opacity(
              opacity: item.isCurrent ? 1 : 0.6,
              child: Text(item.name,
                  style: AppTextStyles.regularText(color: backgroundColor)),
            ),
            Opacity(
              opacity: item.isCurrent ? 1 : 0.6,
              child: Text(
                '${DateFormat('HH:mm').format(item.startAt)} - ${DateFormat('HH:mm').format(item.endAt)}',
                style: AppTextStyles.detailedInfoText(color: backgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Column _buildMealTimeColumn(
//       String mealName, String startTime, String endTime) {
//     DateTime now = DateTime.now();
//     DateFormat format = DateFormat('HH:mm');
//     DateTime start = DateTime(now.year, now.month, now.day).add(
//       Duration(
//         hours: format.parse(startTime).hour,
//         minutes: format.parse(startTime).minute,
//       ),
//     );
//     DateTime end = DateTime(now.year, now.month, now.day).add(
//       Duration(
//         hours: format.parse(endTime).hour,
//         minutes: format.parse(endTime).minute,
//       ),
//     );
//     final isCurrentTime = now.isAfter(start) && now.isBefore(end);
//     final textStyle = isCurrentTime
//         ? AppTextStyles.detailedInfoText()
//             .copyWith(color: mainColor, fontWeight: FontWeight.w700)
//         : AppTextStyles.detailedInfoText();

//     return Column(
//       children: [
//         Text(mealName, style: textStyle),
//         Text('$startTime ~ $endTime', style: textStyle),
//       ],
//     );
//   }
}
