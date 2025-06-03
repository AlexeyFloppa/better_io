import '../entities/task.dart';

abstract class TaskRepository {
  Future<Task> getTask(String id); // <-- change int to String

  Future<List<Task>> getTasks();

  Future<void> setTask(Task task);

  Future<void> deleteTask(String id);
}
