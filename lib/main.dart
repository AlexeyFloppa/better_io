import 'dart:developer';

import 'package:better_io/features/tasks/data/data_sources/task_data_source.dart';
import 'package:flutter/material.dart';

import 'package:better_io/app.dart';

/// Entry point for the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    TaskDataSource taskDataSource = TaskDataSource();
    await taskDataSource.init();
  } catch (e) {
    log("Error initializing Hive: $e");
  }
  runApp(App());
}
