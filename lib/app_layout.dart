import 'package:better_io/shared/widgets/responsive_navigation.dart';
import 'package:flutter/material.dart';

import 'package:better_io/features/home/home_screen.dart';

import 'package:better_io/features/courses/presentation/1.dart';
import 'package:better_io/features/courses/presentation/2.dart';
import 'package:better_io/features/courses/presentation/3.dart';


class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  AppLayoutState createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout> {
  int _selectedTabIndex = 0;
  int _selectedSectionIndex = 0;

  final List<Map<String, dynamic>> _screens = [
    {
      'title': 'Home',
      'tabs': [
        {'widget': const HomeScreen(), 'icon': Icons.home, 'title': 'Home Tab'},
        {'widget': const Example2Screen(), 'icon': Icons.star, 'title': 'Favorites Tab'},
        {'widget': const Example3Screen(), 'icon': Icons.settings, 'title': 'Settings Tab'},
      ],
      'icon': Icons.home,
    },
    {
      'title': 'Schedule',
      'tabs': [
        {'widget': const Example1Screen(), 'icon': Icons.extension, 'title': 'Calendars Tab'},
        {'widget': const Example2Screen(), 'icon': Icons.extension, 'title': 'Challanges Tab'},
        {'widget': const Example3Screen(), 'icon': Icons.analytics, 'title': 'Analysis Tab'},
      ],
      'icon': Icons.calendar_today,
    },
    {
      'title': 'Feed',
      'tabs': [
        {'widget': const Example1Screen(), 'icon': Icons.feed, 'title': 'Feed Tab'},
        {'widget': const Example2Screen(), 'icon': Icons.notifications, 'title': 'Notifications Tab'},
        {'widget': const Example3Screen(), 'icon': Icons.message, 'title': 'Messages Tab'},
      ],
      'icon': Icons.people,
    },
    {
      'title': 'Library',
      'tabs': [
        {'widget': const Example1Screen(), 'icon': Icons.library_books, 'title': 'Library Tab'},
        {'widget': const Example2Screen(), 'icon': Icons.bookmark, 'title': 'Bookmarks Tab'},
        {'widget': const Example3Screen(), 'icon': Icons.folder, 'title': 'Folders Tab'},
      ],
      'icon': Icons.extension,
    },
    {
      'title': 'Recent',
      'tabs': [
        {'widget': const Example1Screen(), 'icon': Icons.history, 'title': 'Recent Tab'},
        {'widget': const Example2Screen(), 'icon': Icons.restore, 'title': 'Restore Tab'},
        {'widget': const Example3Screen(), 'icon': Icons.update, 'title': 'Updates Tab'},
      ],
      'icon': Icons.archive,
    },
    {
      'title': 'Overview',
      'tabs': [
        {'widget': const Example1Screen(), 'icon': Icons.lock, 'title': 'Overview Tab'},
        {'widget': const Example2Screen(), 'icon': Icons.security, 'title': 'Security Tab'},
        {'widget': const Example3Screen(), 'icon': Icons.visibility, 'title': 'Visibility Tab'},
      ],
      'icon': Icons.lock,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentSection = _screens[_selectedSectionIndex];
    final currentTabs = currentSection['tabs'] as List<Map<String, dynamic>>;
    

    return ResponsiveNavigation(
      scaffoldContent: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Scaffold(
          body: currentTabs[_selectedTabIndex]['widget'] as Widget,
        ),
      ),
      sections: _screens,
      tabs: currentTabs,
      selectedSectionIndex: _selectedSectionIndex,
      selectedTabIndex: _selectedTabIndex,
      onSectionSelected: (index) {
        setState(() {
          _selectedSectionIndex = index;
          _selectedTabIndex = 0; // Reset tab index when section changes
        });
      },
      onTabSelected: (index) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
    );
  }
}