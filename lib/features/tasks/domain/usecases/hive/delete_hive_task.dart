import '../../repositories/task_repository.dart';

/// Use case to delete a task by its ID.
class DeleteHiveTaskUseCase {
  final TaskRepository repository;

  DeleteHiveTaskUseCase(this.repository);

  /// Deletes the task with the given ID.
  void execute(String id) {
    repository.deleteTask(id);
  }
}