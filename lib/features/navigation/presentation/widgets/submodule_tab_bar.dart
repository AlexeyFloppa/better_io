import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmoduleTabBar extends StatelessWidget implements PreferredSizeWidget {
  const SubmoduleTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavController>(
      builder: (context, controller, _) {
        final submodules = NavSelector.getSubmodules(controller);
        final selectedId = controller.selectedSubmoduleId;
        final selectedIndex =
            submodules.indexWhere((sub) => sub.id == selectedId);

        return DefaultTabController(
          length: submodules.length,
          initialIndex: selectedIndex >= 0 ? selectedIndex : 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
            ),
            child: TabBar(
              isScrollable: false,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodyMedium?.color,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              tabs: submodules
                  .map(
                    (sub) => Tab(
                      icon: Icon(sub.icon, size: 20),
                      text: sub.title,
                    ),
                  )
                  .toList(),
              onTap: (index) {
                final submodule = submodules[index];
                controller.navigateTo(
                  controller.selectedSectionId,
                  controller.selectedModuleId,
                  submodule.id,
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
