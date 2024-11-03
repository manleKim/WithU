import 'package:cbhs/common/const/font_styles.dart';
import 'package:flutter/material.dart';

class PickedDate extends StatelessWidget {
  final String title;
  final DateTime date;
  final Color color;

  const PickedDate(
      {required this.title,
      required this.date,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.detailedInfoText(color: color)),
        Row(
          children: [
            Text('${date.day}', style: AppTextStyles.mainHeading(color: color)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //date의 Year과 Month
                Text('${date.year}년 ${date.month.toString()}월',
                    style: AppTextStyles.detailedInfoText(color: color)),
                //date의 요일
                Text(_getWeekdayName(date.weekday),
                    style: AppTextStyles.detailedInfoText(color: color)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _getWeekdayName(int weekday) {
    // 날짜의 요일을 반환하는 함수
    switch (weekday) {
      case DateTime.monday:
        return '월요일';
      case DateTime.tuesday:
        return '화요일';
      case DateTime.wednesday:
        return '수요일';
      case DateTime.thursday:
        return '목요일';
      case DateTime.friday:
        return '금요일';
      case DateTime.saturday:
        return '토요일';
      case DateTime.sunday:
        return '일요일';
      default:
        return '';
    }
  }
}
