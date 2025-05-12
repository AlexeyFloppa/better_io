// ignore_for_file: unused_local_variable

import 'package:better_io/app.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/models/hive_color_adapter.dart';



/// Main entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Initialize Hive and register adapters.
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ColorAdapter());

  // Open the Hive box for tasks.
    final taskBox = await Hive.openBox<HiveTaskModel>('tasks');
  runApp(App()); // Wrap MyApp with ProviderScope
}


