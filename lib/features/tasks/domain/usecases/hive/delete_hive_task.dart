import '../../repositories/task_repository.dart';

class DeleteHiveTaskUseCase {
  final TaskRepository repository;

  DeleteHiveTaskUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteTask(id);
  }
}
