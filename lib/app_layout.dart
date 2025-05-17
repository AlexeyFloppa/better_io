// import 'package:better_io/features/tasks/presentation/screens/calendars/calendars_screen.dart';
// import 'package:better_io/shared/widgets/responsive_navigation.dart';
// import 'package:flutter/material.dart';

// import 'package:better_io/features/home/home_screen.dart';

// import 'package:better_io/features/courses/presentation/1.dart';
// import 'package:better_io/features/courses/presentation/2.dart';
// import 'package:better_io/features/courses/presentation/3.dart';


// class AppLayout extends StatefulWidget {
//   const AppLayout({super.key});

//   @override
//   AppLayoutState createState() => AppLayoutState();
// }

// class AppLayoutState extends State<AppLayout> {
//   int _selectedTabIndex = 0;
//   int _selectedSectionIndex = 0;

//   final List<Map<String, dynamic>> _screens = [
//     {
//       'title': 'Home',
//       'tabs': [
//         {'widget': const HomeScreen(), 'icon': Icons.home, 'title': 'Home '},
//         {'widget': const Example2Screen(), 'icon': Icons.star, 'title': 'Favorites '},
//         {'widget': const Example3Screen(), 'icon': Icons.settings, 'title': 'Settings '},
//       ],
//       'icon': Icons.home,
//     },
//     {
//       'title': 'Schedule',
//       'tabs': [
//         {'widget': const CalendarsScreen(), 'icon': Icons.extension, 'title': 'Calendars '},
//         {'widget': const Example2Screen(), 'icon': Icons.extension, 'title': 'Challanges '},
//         {'widget': const Example3Screen(), 'icon': Icons.analytics, 'title': 'Analysis '},
//       ],
//       'icon': Icons.calendar_today,
//     },
//     {
//       'title': 'Feed',
//       'tabs': [
//         {'widget': const Example1Screen(), 'icon': Icons.feed, 'title': 'Feed '},
//         {'widget': const Example2Screen(), 'icon': Icons.notifications, 'title': 'Notifications '},
//         {'widget': const Example3Screen(), 'icon': Icons.message, 'title': 'Messages '},
//       ],
//       'icon': Icons.people,
//     },
//     {
//       'title': 'Library',
//       'tabs': [
//         {'widget': const Example1Screen(), 'icon': Icons.library_books, 'title': 'Library '},
//         {'widget': const Example2Screen(), 'icon': Icons.bookmark, 'title': 'Bookmarks '},
//         {'widget': const Example3Screen(), 'icon': Icons.folder, 'title': 'Folders '},
//       ],
//       'icon': Icons.extension,
//     },
//     {
//       'title': 'Recent',
//       'tabs': [
//         {'widget': const Example1Screen(), 'icon': Icons.history, 'title': 'Recent '},
//         {'widget': const Example2Screen(), 'icon': Icons.restore, 'title': 'Restore '},
//         {'widget': const Example3Screen(), 'icon': Icons.update, 'title': 'Updates '},
//       ],
//       'icon': Icons.archive,
//     },
//     {
//       'title': 'Overview',
//       'tabs': [
//         {'widget': const Example1Screen(), 'icon': Icons.lock, 'title': 'Overview '},
//         {'widget': const Example2Screen(), 'icon': Icons.security, 'title': 'Security '},
//         {'widget': const Example3Screen(), 'icon': Icons.visibility, 'title': 'Visibility '},
//       ],
//       'icon': Icons.lock,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final currentSection = _screens[_selectedSectionIndex];
//     final currentTabs = currentSection['tabs'] as List<Map<String, dynamic>>;
    

//     return ResponsiveNavigation(
//       scaffoldContent: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Scaffold(
//           body: currentTabs[_selectedTabIndex]['widget'] as Widget,
//         ),
//       ),
//       sections: _screens,
//       tabs: currentTabs,
//       selectedSectionIndex: _selectedSectionIndex,
//       selectedTabIndex: _selectedTabIndex,
//       onSectionSelected: (index) {
//         setState(() {
//           _selectedSectionIndex = index;
//           _selectedTabIndex = 0; // Reset tab index when section changes
//         });
//       },
//       onTabSelected: (index) {
//         setState(() {
//           _selectedTabIndex = index;
//         });
//       },
//     );
//   }
// }