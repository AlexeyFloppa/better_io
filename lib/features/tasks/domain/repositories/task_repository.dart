import '../entities/task.dart';

/// Abstract repository interface for managing tasks.
abstract class TaskRepository {
  /// Returns all stored tasks.
  Future<List<Task>> getTasks();



  /// Adds a new task.
  Future<void> setTask(Task task);

  /// Deletes a task by ID.
  Future<void> deleteTask(String id);
}
