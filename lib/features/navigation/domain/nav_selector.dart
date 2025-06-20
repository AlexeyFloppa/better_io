import 'nav_controller.dart';
import '../data/nav_tree.dart';
import 'models/section_nav_data.dart';
import 'models/module_nav_data.dart';
import 'models/submodule_nav_data.dart';

class NavSelector {
  static SectionNavData getCurrentSection(NavController controller) {
    return appSections.firstWhere(
      (section) => section.id == controller.selectedSectionId,
      orElse: () => appSections.first,
    );
  }

  static ModuleNavData getCurrentModule(NavController controller) {
    final section = getCurrentSection(controller);
    return section.modules.firstWhere(
      (module) => module.id == controller.selectedModuleId,
      orElse: () => section.modules.first,
    );
  }

  static SubmoduleNavData? getCurrentSubmodule(NavController controller) {
    final module = getCurrentModule(controller);
    if (module.submodules.isEmpty) {
      return null;
    }
    return module.submodules.firstWhere(
      (sub) => sub.id == controller.selectedSubmoduleId,
      orElse: () => module.submodules.first,
    );
  }

  static List<SectionNavData> get sections => appSections;

  static List<ModuleNavData> getModules(NavController controller) =>
      getCurrentSection(controller).modules;

  static List<SubmoduleNavData> getSubmodules(NavController controller) =>
      getCurrentModule(controller).submodules;

  static String? getFirstSubmoduleId(ModuleNavData module) {
    return module.submodules.isNotEmpty ? module.submodules.first.id : null;
  }
}
