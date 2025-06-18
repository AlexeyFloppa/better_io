import 'package:flutter/material.dart';
import 'submodule_nav_data.dart';

class ModuleNavData {
  final String id;
  final String title;
  final IconData icon;
  final List<Widget> appBarActions;
  final Widget screen;
  final Widget bottomButton;
  final List<SubmoduleNavData> submodules;

  const ModuleNavData({
    required this.id,
    required this.title,
    required this.icon,
    this.appBarActions = const [],
    this.screen = const SizedBox.shrink(),
    this.bottomButton = const SizedBox.shrink(),
    this.submodules = const [],
  });
}
