import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/qr/components/qr_dialog.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final AppBar? appbar;
  final Widget? bottomNavigationBar;
  final bool isFloatingButton;

  const DefaultLayout(
      {required this.child,
      this.backgroundColor,
      this.appbar,
      this.bottomNavigationBar,
      this.isFloatingButton = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: appbar,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isFloatingButton
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => const QrDialog());
              },
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 1,
              child: const Icon(Icons.qr_code),
            )
          : null,
    );
  }
}
