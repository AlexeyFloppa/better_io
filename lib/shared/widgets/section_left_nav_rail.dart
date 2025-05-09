import 'package:flutter/material.dart';

class SectionNavigationRail extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SectionNavigationRail({
    Key? key,
    required this.sections,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.none, // Hide section titles
      destinations: sections.map((section) {
        return NavigationRailDestination(
          icon: Icon(section['icon']),
          selectedIcon: Icon(section['icon'], color: Theme.of(context).primaryColor),
          label: const SizedBox.shrink(), // Empty label
        );
      }).toList(),
    );
  }
}