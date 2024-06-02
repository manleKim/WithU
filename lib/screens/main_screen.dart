import 'package:cbhs/screens/home_screen.dart';
import 'package:cbhs/screens/meal/meal_screen.dart';
import 'package:cbhs/screens/myPage/my_page_screen.dart';
import 'package:cbhs/screens/overNight/over_night_screen.dart';
import 'package:cbhs/style.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: const HomeScreen(),
            item: ItemConfig(
                icon: const Icon(Icons.home_outlined),
                title: "종합홈",
                activeForegroundColor: AppColor.cyan),
          ),
          PersistentTabConfig(
            screen: const OverNightScreen(),
            item: ItemConfig(
                icon: const Icon(Icons.bedtime_outlined),
                title: "외박",
                activeForegroundColor: AppColor.cyan),
          ),
          PersistentTabConfig(
            screen: const MealScreen(),
            item: ItemConfig(
                icon: const Icon(Icons.food_bank_outlined),
                title: "식단",
                activeForegroundColor: AppColor.cyan),
          ),
          PersistentTabConfig(
            screen: const MyPageScreen(),
            item: ItemConfig(
                icon: const Icon(Icons.account_circle_outlined),
                title: "마이페이지",
                activeForegroundColor: AppColor.cyan),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
              navBarConfig: navBarConfig,
            ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.qr_code)));
  }
}
