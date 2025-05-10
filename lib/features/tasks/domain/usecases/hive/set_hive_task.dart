import '../../repositories/task_repository.dart';
import '../../entities/task.dart';

/// Use case to set a new task to the repository.
class SetHiveTaskUseCase {
  final TaskRepository repository;

  SetHiveTaskUseCase(this.repository);

  /// Sets the given task to the repository.
  Future<void> execute(Task task) async {
    await repository.setTask(task);
  }
}