import 'package:hive_flutter/hive_flutter.dart';
import 'package:better_io/features/tasks/data/models/task_model.dart';
import 'package:better_io/features/tasks/data/adaptors/hive_color_adapter.dart';

class TaskDataSource {
  static const String _boxName = 'tasks';
  late Box<TaskModel> taskBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(HiveColorAdapter());
    taskBox = await Hive.openBox<TaskModel>(_boxName);
  }
}
