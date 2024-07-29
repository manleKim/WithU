import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/meal/view/meal_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: mainColor,
        unselectedItemColor: greyNavigationColor,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "외박"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "식단"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "마이페이지"),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          Center(child: Text('홈')),
          Center(child: Text('외박')),
          MealScreen(),
          Center(child: Text('마이페이지')),
        ],
      ),
    );
  }
}
