import '../../repositories/task_repository.dart';
import '../../entities/task.dart';

class SetHiveTaskUseCase {
  final TaskRepository repository;

  SetHiveTaskUseCase(this.repository);

  Future<void> execute(Task task) async {
    await repository.setTask(task);
  }
}
