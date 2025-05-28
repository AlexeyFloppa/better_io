import '../../repositories/task_repository.dart';

class DeleteHiveTaskUseCase {
  final TaskRepository repository;

  DeleteHiveTaskUseCase(this.repository);

  void execute(String id) {
    repository.deleteTask(id);
  }
}
