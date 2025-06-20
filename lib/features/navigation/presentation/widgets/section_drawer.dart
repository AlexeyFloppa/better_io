import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionDrawer extends StatelessWidget {
  const SectionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavController>(
      builder: (context, controller, _) {
        final sections = NavSelector.sections;
        final selectedId = controller.selectedSectionId;

        return Drawer(
          child: SafeArea(
            child: ListView(
              children: sections.map((section) {
                final isSelected = section.id == selectedId;
                return ListTile(
                  leading: Icon(section.icon),
                  title: Text(section.title),
                  selected: isSelected,
                  onTap: () {
                    final firstModule = section.modules.first;
                    final firstSubmodule =
                        NavSelector.getFirstSubmoduleId(firstModule);
                    controller.navigateTo(
                      section.id,
                      firstModule.id,
                      firstSubmodule,
                    );
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
