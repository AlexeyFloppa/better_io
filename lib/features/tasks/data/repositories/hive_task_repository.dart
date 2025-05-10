import 'package:better_io/features/tasks/domain/repositories/task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:hive/hive.dart';
import '../models/hive_task_model.dart';

class HiveTaskRepository implements TaskRepository {
  final Box<HiveTaskModel> _taskBox;

  HiveTaskRepository(this._taskBox);

  @override
  Future<List<Task>> getTasks() async {
    return _taskBox.values.map((hiveTask) => _mapToDomain(hiveTask)).toList();
  }


  @override
  Future<void> setTask(Task task) async {
    final hiveTask = _mapToHive(task);
    await _taskBox.add(hiveTask);
  }

  @override
  Future<void> deleteTask(String id) async {
    final taskKey = _taskBox.keys.firstWhere((key) => _taskBox.get(key)?.taskId == id, orElse: () => null);
    if (taskKey != null) {
      await _taskBox.delete(taskKey);
    }
  }

  Task _mapToDomain(HiveTaskModel hiveTask) {
    return Task(
      id: hiveTask.taskId.toString(),
      title: hiveTask.title,
      description: hiveTask.description,
      color: hiveTask.color,
      startDate: hiveTask.startDate,
      endDate: hiveTask.endDate,
      isAllDay: hiveTask.isAllDay,
      isRecurring: hiveTask.isRecurring,
      recurrenceType: hiveTask.recurrenceType,
      recurrenceInterval: hiveTask.recurrenceInterval,
      recurrenceDays: hiveTask.recurrenceDays,
      duration: hiveTask.duration,
      priority: hiveTask.priority,
    );
  }

  HiveTaskModel _mapToHive(Task task) {
    return HiveTaskModel(
      taskId: int.parse(task.id),
      title: task.title,
      description: task.description,
      color: task.color,
      startDate: task.startDate,
      endDate: task.endDate,
      isAllDay: task.isAllDay,
      isRecurring: task.isRecurring,
      recurrenceType: task.recurrenceType,
      recurrenceInterval: task.recurrenceInterval,
      recurrenceDays: task.recurrenceDays,
      duration: task.duration,
      priority: task.priority,
    );
  }
}