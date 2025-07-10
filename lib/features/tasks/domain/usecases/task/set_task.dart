import '../../repositories/task_repository.dart';
import '../../entities/task.dart';

class SetTaskUseCase {
  final ITaskRepository repository;

  SetTaskUseCase(this.repository);

  Future<void> execute(Task task) async {
    await repository.setTask(task);
  }
}
