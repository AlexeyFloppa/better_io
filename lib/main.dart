import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:better_io/app.dart';
import 'features/tasks/data/models/hive/hive_task_model.dart';
import 'package:better_io/features/tasks/data/models/hive/hive_color_adapter.dart';

/// Entry point for the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveTaskModelAdapter());
    Hive.registerAdapter(ColorAdapter());
    await Hive.openBox<HiveTaskModel>('tasks');
  } catch (e) {
    log("Error initializing Hive: $e");
  }
  runApp(App());
}
