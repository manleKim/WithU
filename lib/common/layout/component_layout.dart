import 'package:cbhs/common/const/colors.dart';
import 'package:flutter/material.dart';

class ComponentLayout extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double? radius;

  const ComponentLayout(
      {required this.child, this.width, this.height, this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 15),
      child: Container(
        color: greyLightColor,
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
