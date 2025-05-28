import 'package:flutter/material.dart';

class AppNavigator {
  static final ValueNotifier<int> currentScreenIndex = ValueNotifier<int>(0);

  static void navigateTo(int index) {
    currentScreenIndex.value = index;
  }
}
