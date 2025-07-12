import 'package:better_io/features/tasks/domain/entities/task_priority.dart';
import 'package:better_io/features/tasks/domain/repositories/task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/entities/task_category.dart';
import 'package:hive/hive.dart';
import 'package:better_io/features/tasks/data/models/task_model.dart';

class TaskRepository implements ITaskRepository {
  final Box<TaskModel> _taskBox;

  TaskRepository(this._taskBox);

  @override
  Future<Task> getTask(String id) async {
    final newTask = _taskBox.get(id);
    if (newTask == null) throw Exception('Task not found');
    return _mapToDomain(newTask, id);
  }

  @override
  Future<List<Task>> getTasks() async {
    return _taskBox.keys.map((key) {
      final newTask = _taskBox.get(key)!;
      return _mapToDomain(newTask, key);
    }).toList();
  }

  @override
  Future<void> setTask(Task task) async {
    final newTask = _mapToHive(task);
    await _taskBox.put(task.id, newTask); // overwrite by ID
  }

  @override
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Task _mapToDomain(TaskModel task, String key) {
    return Task(
      id: key, // use Hive key as ID
      title: task.title,
      description: task.description,
      color: task.color,
      startDate: task.startDate,
      endDate: task.endDate,
      isDateTied: task.isDateTied,
      recurrenceRule: task.recurrenceRule,
      recurrenceExceptionDates: task.recurrenceExceptionDates,
      duration: task.duration,
      priority: task.priority.isNotEmpty
          ? TaskPriorityExtension.fromString(task.priority)
          : TaskPriority.none,
      category: task.category.isNotEmpty
          ? TaskCategoryExtension.fromString(task.category)
          : TaskCategory.general,
    );
  }

  TaskModel _mapToHive(Task task) {
    return TaskModel(
      title: task.title,
      description: task.description,
      color: task.color,
      startDate: task.startDate,
      endDate: task.endDate,
      isDateTied: task.isDateTied,
      recurrenceRule: task.recurrenceRule,
      recurrenceExceptionDates: task.recurrenceExceptionDates,
      duration: task.duration,
      priority: task.priority.name,
      category: task.category.name,
    );
  }
}
