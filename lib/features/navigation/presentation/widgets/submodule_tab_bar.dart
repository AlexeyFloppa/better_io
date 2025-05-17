import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmoduleTabBar extends StatelessWidget implements PreferredSizeWidget {
  const SubmoduleTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NavController>(context);
    final submodules = NavSelector.getSubmodules(controller);
    final selectedId = controller.selectedSubmoduleId;
    final selectedIndex =
        submodules.indexWhere((sub) => sub.id == selectedId);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,

      ),
      child: TabBar(
        isScrollable: false,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        tabs: submodules
            .map(
              (sub) => Tab(
                icon: Icon(sub.icon, size: 20),
                text: sub.title,
              ),
            )
            .toList(),
        onTap: (index) {
          controller.setSubmodule(submodules[index].id);
        },
        controller: TabController(
          length: submodules.length,
          vsync: Scaffold.of(context),
          initialIndex: selectedIndex >= 0 ? selectedIndex : 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
