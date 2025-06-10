import 'package:better_io/features/tasks/domain/repositories/task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:hive/hive.dart';
import 'package:better_io/features/tasks/data/models/hive_task_model.dart';

class HiveTaskRepository implements TaskRepository {
  final Box<HiveTaskModel> _taskBox;

  HiveTaskRepository(this._taskBox);

  @override
  Future<Task> getTask(String id) async {
    final hiveTask = _taskBox.get(id);
    if (hiveTask == null) throw Exception('Task not found');
    return _mapToDomain(hiveTask, id);
  }

  @override
  Future<List<Task>> getTasks() async {
    return _taskBox.keys.map((key) {
      final hiveTask = _taskBox.get(key)!;
      return _mapToDomain(hiveTask, key);
    }).toList();
  }

  @override
  Future<void> setTask(Task task) async {
    final hiveTask = _mapToHive(task);
    await _taskBox.put(task.id, hiveTask); // overwrite by ID
  }

  @override
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Task _mapToDomain(HiveTaskModel hiveTask, String key) {
    return Task(
      id: key, // use Hive key as ID
      title: hiveTask.title,
      description: hiveTask.description,
      color: hiveTask.color,
      startDate: hiveTask.startDate,
      endDate: hiveTask.endDate,
      isAllDay: hiveTask.isAllDay,
      recurrenceRule: hiveTask.recurrenceRule,
      duration: hiveTask.duration,
      priority: hiveTask.priority,
    );
  }

  HiveTaskModel _mapToHive(Task task) {
    return HiveTaskModel(
      title: task.title,
      description: task.description,
      color: task.color,
      startDate: task.startDate,
      endDate: task.endDate,
      isAllDay: task.isAllDay,
      recurrenceRule: task.recurrenceRule,
      duration: task.duration,
      priority: task.priority,
    );
  }
}
