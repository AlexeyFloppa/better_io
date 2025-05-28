import 'package:better_io/app.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/models/hive_color_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ColorAdapter());

  await Hive.openBox<HiveTaskModel>('tasks');
  runApp(const App());
}
