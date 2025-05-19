import 'package:flutter/material.dart';
import 'desktop_layout.dart';
import 'mobile_layout.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return isDesktop ? const DesktopLayout() : const MobileLayout();
  }
}
