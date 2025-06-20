import 'package:better_io/features/navigation/domain/nav_controller.dart';
import 'package:better_io/features/navigation/domain/nav_selector.dart';
import 'package:better_io/features/navigation/presentation/widgets/mobile_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/section_drawer.dart';
import '../widgets/bottom_module_nav.dart';
import '../widgets/submodule_tab_bar.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NavController>(context);
    final currentModule = NavSelector.getCurrentModule(controller);
    final currentSub = NavSelector.getCurrentSubmodule(controller);

    return Scaffold(
      appBar: MobileAppBar(
        title: currentSub?.title ?? currentModule.title,
      ),
      drawer: const SectionDrawer(),
      body: Column(
        children: [
          if (currentModule.submodules.isNotEmpty) const SubmoduleTabBar(),
          Expanded(
            child: currentSub?.screen ?? currentModule.screen,
          ),
        ],
      ),
      bottomNavigationBar: const BottomModuleNav(),
      floatingActionButton: currentModule.bottomButton,
    );
  }
}
