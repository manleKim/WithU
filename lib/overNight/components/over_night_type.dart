import 'package:cbhs/common/const/font_styles.dart';
import 'package:flutter/material.dart';

class OverNightType extends StatelessWidget {
  final Color color;
  final String typeName;

  const OverNightType({required this.color, required this.typeName, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 4),
        Text(typeName, style: AppTextStyles.regularText())
      ],
    );
  }
}
