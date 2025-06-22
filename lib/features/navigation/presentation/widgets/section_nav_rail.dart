import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionNavRail extends StatelessWidget {
  const SectionNavRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavController>(
      builder: (context, controller, _) {
        final sections = NavSelector.sections;
        final selectedIndex =
            sections.indexWhere((s) => s.id == controller.selectedSectionId);

        return NavigationRail(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onDestinationSelected: (index) {
            final section = sections[index];
            final firstModule = section.modules.first;
            final firstSubmodule = NavSelector.getFirstSubmoduleId(firstModule);
            controller.navigateTo(
              section.id,
              firstModule.id,
              firstSubmodule,
            );
          },
          labelType: NavigationRailLabelType.all,
          destinations: sections
              .map((section) => NavigationRailDestination(
                    icon: Icon(section.icon),
                    label: Text(section.title),
                  ))
              .toList(),
        );
      },
    );
  }
}
