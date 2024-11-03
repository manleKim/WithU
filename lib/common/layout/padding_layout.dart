import 'package:flutter/material.dart';

class PaddingLayout extends StatelessWidget {
  final Widget child;
  final double? top;

  const PaddingLayout({required this.child, this.top, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, top ?? 0, 20, 30),
      child: child,
    );
  }
}
