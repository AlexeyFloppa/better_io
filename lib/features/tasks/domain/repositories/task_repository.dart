import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> setTask(Task task);

  Future<void> deleteTask(String id);
}
