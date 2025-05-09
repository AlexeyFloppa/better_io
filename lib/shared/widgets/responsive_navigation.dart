import 'package:flutter/material.dart';
import 'section_left_nav_rail.dart';
import 'tab_right_nav_rail.dart';
import 'tab_bottom_nav_bar.dart';

class ResponsiveNavigation extends StatelessWidget {
  final Widget scaffoldContent;
  final List<Map<String, dynamic>> sections;
  final List<Map<String, dynamic>> tabs;
  final int selectedSectionIndex;
  final int selectedTabIndex;
  final ValueChanged<int> onSectionSelected;
  final ValueChanged<int> onTabSelected;

  const ResponsiveNavigation({
    Key? key,
    required this.scaffoldContent,
    required this.sections,
    required this.tabs,
    required this.selectedSectionIndex,
    required this.selectedTabIndex,
    required this.onSectionSelected,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final appTitle = tabs[selectedTabIndex]['title']; // Use the selected tab's title

    if (screenWidth >= 1024) {
      // PC Screen Layout
      return Scaffold(
        backgroundColor: ThemeData().colorScheme.surfaceContainerLow, // Surface 1 equivalent
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Row(
          children: [
            SectionNavigationRail(
              sections: sections,
              selectedIndex: selectedSectionIndex,
              onDestinationSelected: onSectionSelected,
            ),
            Expanded(
              child: scaffoldContent,
            ),
            TabNavigationRail(
              tabs: tabs,
              selectedIndex: selectedTabIndex,
              onDestinationSelected: onTabSelected,
            ),
          ],
        ),
      );
    } else if (screenWidth >= 600) {
      // Tablet Screen Layout
      return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Row(
          children: [
            SectionNavigationRail(
              sections: sections,
              selectedIndex: selectedSectionIndex,
              onDestinationSelected: onSectionSelected,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: scaffoldContent,
            ),
            const VerticalDivider(width: 1),
            TabNavigationRail(
              tabs: tabs,
              selectedIndex: selectedTabIndex,
              onDestinationSelected: onTabSelected,
            ),
          ],
        ),
      );
    } else {
      // Mobile Screen Layout
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            ),
          ),
          title: Text(appTitle),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ...sections.asMap().entries.map((entry) {
                return ListTile(
                  leading: Icon(entry.value['icon']),
                  title: Text(entry.value['title']),
                  onTap: () {
                    onSectionSelected(entry.key);
                    Navigator.of(context).pop(); // Close the drawer
                  },
                );
              }).toList(),
            ],
          ),
        ),
        body: scaffoldContent,
        bottomNavigationBar: TabBottomNavBar(
          currentIndex: selectedTabIndex,
          tabs: tabs,
          onTabSelected: onTabSelected,
        ),
      );
    }
  }
}