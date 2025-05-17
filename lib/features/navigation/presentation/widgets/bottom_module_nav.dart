import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomModuleNav extends StatelessWidget {
  const BottomModuleNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NavController>(context);
    final modules = NavSelector.getModules(controller);
    final selectedIndex =
        modules.indexWhere((m) => m.id == controller.selectedModuleId);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        final module = modules[index];
        controller.setModule(module.id);
        controller.setSubmodule(module.submodules.first.id);
      },
      destinations: modules
          .map((m) => NavigationDestination(
                icon: Icon(m.icon),
                label: m.title,
              ))
          .toList(),
    );
  }
}
