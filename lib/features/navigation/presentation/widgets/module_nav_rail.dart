import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleNavRail extends StatelessWidget {
  const ModuleNavRail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NavController>(context);
    final modules = NavSelector.getModules(controller);
    final selectedIndex =
        modules.indexWhere((m) => m.id == controller.selectedModuleId);

    return NavigationRail(
      selectedIndex: selectedIndex,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (index) {
        final module = modules[index];
        controller.setModule(module.id);
        // Only set submodule if there are submodules
        if (module.submodules.isNotEmpty) {
          controller.setSubmodule(module.submodules.first.id);
        }
      },
      destinations: modules
          .map((module) => NavigationRailDestination(
                icon: Icon(module.icon),
                label: Text(module.title),
              ))
          .toList(),
    );
  }
}
