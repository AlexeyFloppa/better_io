import 'package:better_io/app.dart';
import 'package:flutter/material.dart';

/// Main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App()); // Wrap MyApp with ProviderScope
}


