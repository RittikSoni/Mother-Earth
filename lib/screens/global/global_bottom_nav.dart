import 'package:eco_collect/screens/explore/explore.dart';
import 'package:eco_collect/screens/gameplay/solo/solo_gameplay_screen.dart';

import 'package:eco_collect/screens/gchat/gchat.dart';
import 'package:eco_collect/screens/global/widgets/bottom_nav_widget.dart';
import 'package:eco_collect/screens/global/global_app_bar.dart';

import 'package:eco_collect/screens/leaderboard/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class GlobalBottomNav extends StatefulWidget {
  const GlobalBottomNav({super.key});

  @override
  State<GlobalBottomNav> createState() => _GlobalBottomNavState();
}

class _GlobalBottomNavState extends State<GlobalBottomNav> {
  int activeTabIndex = 0;
  final List<Widget> _screens = [
    const SoloGameplayScreen(),
    const GChat(),
    const Leaderboard(),
    const Explore(),
  ];

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (ctx) {
          return Scaffold(
            bottomNavigationBar: BottomNavWidget(
              onTapTab: (p0) {
                setState(() {
                  activeTabIndex = p0;
                });
              },
              currentActiveIndex: activeTabIndex,
            ),
            appBar: globalAppBar(ctx),
            body: _screens[activeTabIndex],
          );
        },
      ),
    );
  }
}
