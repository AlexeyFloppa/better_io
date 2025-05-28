import 'package:better_io/features/navigation/presentation/layout/adaptive_layout.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'features/navigation/domain/nav_controller.dart';

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
      themeMode: ThemeMode.system,
      home: ChangeNotifierProvider(
        create: (_) => NavController(),
        child: AdaptiveLayout(),
      ),
      navigatorObservers: [routeObserver],
    );
  }
}
