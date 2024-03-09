import 'package:eco_collect/constants/ktheme.dart';
import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget(
      {super.key, required this.onTapTab, required this.currentActiveIndex});
  final Function(int) onTapTab;
  final int currentActiveIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: KTheme.globalBottomNavActiveTab,
      unselectedItemColor: KTheme.globalBottomNavInActiveTab,
      items: const [
        // My Home
        BottomNavigationBarItem(
          backgroundColor: KTheme.globalBottomNavBG,
          icon: Icon(Icons.home_max_rounded),
          label: 'My Home',
          tooltip: 'My Home',
        ),

        // Global chat
        BottomNavigationBarItem(
          icon: Icon(Icons.leak_add),
          label: 'G-Chat',
          tooltip: 'G-Chat',
        ),

        // Leaderboard - Heroes - Env_roe
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Heroes',
          tooltip: 'Heroes',
        ),

        // More
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
          tooltip: 'Explore',
        ),
      ],
      onTap: onTapTab,
      currentIndex: currentActiveIndex,
    );
  }
}
