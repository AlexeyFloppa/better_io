import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 26, 115, 232),
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 26, 115, 232),
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ThemeData().colorScheme.surfaceContainerLow,
    ),
  );
}
