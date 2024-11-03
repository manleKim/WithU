import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleGraph extends StatelessWidget {
  final int currentValue;
  final int maxValue;

  const CircleGraph({
    super.key,
    required this.currentValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    double progress = currentValue / maxValue;

    return SizedBox(
      width: 67, // 원그래프의 너비
      height: 67, // 원그래프의 높이
      child: CustomPaint(
        painter: CircleGraphPainter(progress),
        child: Center(
          child: Text(
            '$currentValue/$maxValue',
            style:
                AppTextStyles.basicText().copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class CircleGraphPainter extends CustomPainter {
  final double progress;
  final double strokeWidth = 15;

  CircleGraphPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final paintProgress = Paint()
      ..color = mainColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(center, radius, paint);
    canvas.drawArc(
        rect, -math.pi / 2, 2 * math.pi * progress, false, paintProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
