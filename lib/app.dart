import 'package:better_io/app_layout.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Better.io',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Use system theme preference
      home: AppLayout(),
      navigatorObservers: [routeObserver], // Add RouteObserver here
    );
  }
}
