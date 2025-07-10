import '../../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final ITaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteTask(id);
  }
}
