import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:better_io/app.dart';
import 'features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/models/hive_color_adapter.dart';

/// Entry point for the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(ColorAdapter());
    await Hive.openBox<HiveTaskModel>('tasks');
  } catch (e) {
    // Optionally log or handle initialization error
  }
  runApp(App());
}
