import 'package:flutter/material.dart';

class TabBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<Map<String, dynamic>> tabs;
  final ValueChanged<int> onTabSelected;

  const TabBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.tabs,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabSelected,
      showSelectedLabels: false, // Hide selected tab title
      showUnselectedLabels: false, // Hide unselected tab titles
      items: tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab['icon']),
          label: '', // Empty label
        );
      }).toList(),
    );
  }
}
