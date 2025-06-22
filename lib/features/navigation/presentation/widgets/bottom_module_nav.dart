import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomModuleNav extends StatelessWidget {
  const BottomModuleNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavController>(
      builder: (context, controller, _) {
        final modules = NavSelector.getModules(controller);
        final selectedIndex =
            modules.indexWhere((m) => m.id == controller.selectedModuleId);

        return NavigationBar(
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onDestinationSelected: (index) {
            final module = modules[index];
            final firstSubmodule = NavSelector.getFirstSubmoduleId(module);
            controller.navigateTo(
              controller.selectedSectionId,
              module.id,
              firstSubmodule,
            );
          },
          destinations: modules
              .map((m) => NavigationDestination(
                    icon: Icon(m.icon),
                    label: m.title,
                  ))
              .toList(),
        );
      },
    );
  }
}
