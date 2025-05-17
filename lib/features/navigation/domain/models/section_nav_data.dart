import 'package:flutter/material.dart';
import 'module_nav_data.dart';

class SectionNavData {
  final String id;
  final String title;
  final IconData icon;
  final List<ModuleNavData> modules;

  const SectionNavData({
    required this.id,
    required this.title,
    required this.icon,
    required this.modules,
  });
}
