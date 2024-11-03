import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:flutter/material.dart';

class RewardPenaltyGraph extends StatelessWidget {
  final int points;

  const RewardPenaltyGraph({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final clampedPoints = points.clamp(-100, 100).toDouble();

    return CustomPaint(
      size: const Size(
          double.infinity, 70), // Increase height to accommodate labels
      painter: _RewardPenaltyGraphPainter(clampedPoints),
    );
  }
}

class _RewardPenaltyGraphPainter extends CustomPainter {
  final double points;

  _RewardPenaltyGraphPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final center = size.width / 2;
    final totalLength = size.width;

    // Draw the white baseline
    paint.color = Colors.white;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Draw the tick marks and labels
    final tickPositions = [-100, -50, 0, 50, 100];
    for (final tick in tickPositions) {
      final tickX = center + (tick / 100) * (totalLength / 2);

      // Draw the label
      textPainter.text = TextSpan(
        text: tick > 0 ? '+$tick점' : '$tick점',
        style: AppTextStyles.detailedInfoText(color: greyMiddleColor),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(tickX - textPainter.width / 2, size.height / 2 - 30),
      );
    }

    // Draw the filled portion based on points
    if (points != 0) {
      paint.color = points > 0 ? mainColor : Colors.red;

      double startX = center;
      double endX = center + (points / 100) * (totalLength / 2);

      if (points < 0) {
        startX = center;
        endX = center + (points / 100) * (totalLength / 2);
      }

      paint.strokeWidth = 10;
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        paint,
      );

      // Draw the light circle at the current point location
      final circlePaint = Paint()
        ..color = paint.color.withOpacity(0.5)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(endX, size.height / 2), 10, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
