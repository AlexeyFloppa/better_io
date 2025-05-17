import 'package:flutter/material.dart';

class SubmoduleNavData {
  final String id;
  final String title;
  final IconData icon;
  final Widget screen;

  const SubmoduleNavData({
    required this.id,
    required this.title,
    required this.icon,
    required this.screen,
  });
}
