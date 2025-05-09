import 'package:flutter/material.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255,26, 115, 232),
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow, // Surface 1 equivalent
      scrolledUnderElevation: 0, // Prevents background color change on scroll
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255,26, 115, 232),
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
      scrolledUnderElevation: 0, // Prevents background color change on scroll
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
  );
}
