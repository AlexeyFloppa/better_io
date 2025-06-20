import 'package:flutter/material.dart';

class NavController extends ChangeNotifier {
  String selectedSectionId = 'home';
  String selectedModuleId = 'home_main';
  String selectedSubmoduleId = 'home';

  void setSection(String id) {
    selectedSectionId = id;
    notifyListeners();
  }

  void setModule(String id) {
    selectedModuleId = id;
    notifyListeners();
  }

  void setSubmodule(String id) {
    selectedSubmoduleId = id;
    notifyListeners();
  }

  void reset() {
    selectedSectionId = 'home';
    selectedModuleId = 'home_main';
    selectedSubmoduleId = 'home';
    notifyListeners();
  }

  void navigateTo(String sectionId, String moduleId, [String? submoduleId]) {
    setSection(sectionId);
    setModule(moduleId);
    if (submoduleId != null) {
      setSubmodule(submoduleId);
    } else {
      setSubmodule('');
    }
  }
}
