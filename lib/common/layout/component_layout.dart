import 'package:cbhs/common/const/colors.dart';
import 'package:flutter/material.dart';

class ComponentLayout extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const ComponentLayout(
      {required this.child, this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: grayLightColor,
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
