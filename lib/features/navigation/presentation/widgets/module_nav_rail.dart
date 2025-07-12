import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleNavRail extends StatelessWidget {
  const ModuleNavRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavController>(
      builder: (context, controller, _) {
        final modules = NavSelector.getModules(controller);
        final selectedIndex =
            modules.indexWhere((m) => m.id == controller.selectedModuleId);

        final currentModule =
            selectedIndex >= 0 && selectedIndex < modules.length
                ? modules[selectedIndex]
                : null;

        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          width: 90,
          child: Column(
            children: [
              Expanded(
                child: NavigationRail(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (index) {
                    final module = modules[index];
                    final firstSubmodule =
                        NavSelector.getFirstSubmoduleId(module);
                    controller.navigateTo(
                      controller.selectedSectionId,
                      module.id,
                      firstSubmodule,
                    );
                  },
                  destinations: modules
                      .map((module) => NavigationRailDestination(
                            icon: Icon(module.icon),
                            label: Text(module.title),
                          ))
                      .toList(),
                ),
              ),
              // TODO: Rewrite it because if we have no button, we have shrink sized box, with padding, which is not good
              if (currentModule?.bottomButton != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: currentModule!.bottomButton,
                ),
            ],
          ),
        );
      },
    );
  }
}
