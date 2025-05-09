import 'package:flutter/material.dart';

class TabNavigationRail extends StatelessWidget {
  final List<Map<String, dynamic>> tabs;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const TabNavigationRail({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.none, // Hide tab titles
      destinations: tabs.map((tab) {
        return NavigationRailDestination(
          icon: Icon(tab['icon']),
          selectedIcon: Icon(tab['icon'], color: Theme.of(context).primaryColor),
          label: const SizedBox.shrink(), // Empty label
        );
      }).toList(),
    );
  }
}

// Example usage
class NavigationRailExample extends StatefulWidget {
  @override
  _NavigationRailExampleState createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {
      'icon': Icons.home,
      'title': 'Home',
    },
    {
      'icon': Icons.search,
      'title': 'Search',
    },
    {
      'icon': Icons.settings,
      'title': 'Settings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          TabNavigationRail(
            tabs: _tabs,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Center(
              child: Text('Selected Index: $_selectedIndex'),
            ),
          ),
        ],
      ),
    );
  }
}