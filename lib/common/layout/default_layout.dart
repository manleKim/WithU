import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final Widget? bottomNavigationBar;

  const DefaultLayout(
      {required this.child,
      this.backgroundColor,
      this.bottomNavigationBar,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
