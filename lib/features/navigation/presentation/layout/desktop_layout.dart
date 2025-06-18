import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/module_nav_rail.dart';
import '../widgets/section_nav_rail.dart';
import '../widgets/submodule_tab_bar.dart';
import '../widgets/desktop_appbar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NavController>(context);
    final currentModule = NavSelector.getCurrentModule(controller);
    final currentSub = NavSelector.getCurrentSubmodule(controller);

    return Scaffold(
      appBar: DesktopAppBar(
        title: currentModule.title,
        appBarActions: currentModule.appBarActions,
      ),
      body: Row(
        children: [
          const SectionNavRail(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                if (currentModule.submodules.isNotEmpty)
                  const SubmoduleTabBar(),
                Expanded(
                  child: currentSub?.screen ?? currentModule.screen,
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          const ModuleNavRail(),
        ],
      ),
    );
  }
}
