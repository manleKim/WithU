import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/qr/components/qr_dialog.dart';
import 'package:flutter/material.dart';

class PaddingLayout extends StatelessWidget {
  final Widget child;

  const PaddingLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: child,
    );
  }
}
