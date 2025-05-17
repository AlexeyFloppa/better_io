import 'package:better_io/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'submodule_nav_data.dart';

class ModuleNavData {
  final String id;
  final String title;
  final IconData icon;
  final Widget screen;
  final List<SubmoduleNavData> submodules;

  const ModuleNavData({
    required this.id,
    required this.title,
    required this.icon,
    this.screen = const HomeScreen(),
    this.submodules = const [],
  });
}
