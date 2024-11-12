import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/home/view/home_screen.dart';
import 'package:cbhs/meal/view/meal_screen.dart';
import 'package:cbhs/overNight/view/over_night_screen.dart';
import 'package:cbhs/qr/components/qr_dialog.dart';
import 'package:cbhs/user/view/user_me_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'rootTab';

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

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const QrDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isFloatingButton: false,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey, blurRadius: 3)
        ]),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            BottomNavigationBar(
              elevation: 1,
              selectedItemColor: mainColor,
              unselectedItemColor: greyNavigationColor,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 12,
              onTap: (int index) {
                // if (index == 2) {
                //   _showCustomDialog(context);
                // } else {
                controller.animateTo(index);
                // }
              },
              currentIndex: index,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svg/tab/tab_home_out.svg',
                      colorFilter: ColorFilter.mode(
                        index == 0 ? mainColor : greyNavigationColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "홈"),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svg/tab/tab_application_out.svg',
                      colorFilter: ColorFilter.mode(
                        index == 1 ? mainColor : greyNavigationColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "외박/귀향"),
                // BottomNavigationBarItem(
                //     icon: SvgPicture.asset(
                //       'assets/svg/tab/tab_QR.svg',
                //       colorFilter: const ColorFilter.mode(
                //         backgroundColor,
                //         BlendMode.srcIn,
                //       ),
                //     ),
                //     label: ""),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svg/tab/tab_menu.svg',
                      colorFilter: ColorFilter.mode(
                        index == 2 ? mainColor : greyNavigationColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "식단"),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svg/tab/tab_myroom.svg',
                      colorFilter: ColorFilter.mode(
                        index == 3 ? mainColor : greyNavigationColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: "마이룸"),
              ],
            ),
            // Positioned(
            //   left: MediaQuery.of(context).size.width / 2 - 30,
            //   top: -10,
            //   child: GestureDetector(
            //     onTap: () {
            //       _showCustomDialog(context);
            //     },
            //     child: Container(
            //       padding: const EdgeInsets.all(18),
            //       decoration: BoxDecoration(
            //         color: mainColor,
            //         shape: BoxShape.circle,
            //         border: Border.all(color: backgroundColor, width: 4),
            //       ),
            //       child: SvgPicture.asset(
            //         'assets/svg/tab/tab_QR.svg',
            //         colorFilter: const ColorFilter.mode(
            //           backgroundColor,
            //           BlendMode.srcIn,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          HomeScreen(),
          OverNightScreen(),
          // Center(child: Text('QR')),
          MealScreen(),
          UserMeScreen(),
        ],
      ),
    );
  }
}
