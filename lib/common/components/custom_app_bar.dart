import 'package:cbhs/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBars extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? automaticallyImplyLeading;

  const CustomAppBars({
    required this.title,
    this.automaticallyImplyLeading = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: automaticallyImplyLeading!,
      backgroundColor: mainColor,
      foregroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
