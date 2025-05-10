import 'package:better_io/features/tasks/domain/entities/task.dart';
import '../../repositories/task_repository.dart';
import 'dart:developer';

/// Use case to fetch all tasks from Hive.
class GetAllTasksUseCase {
  final TaskRepository repository;

  GetAllTasksUseCase(this.repository);

  /// Fetches all tasks from the repository.
  Future<List<Task>> execute() async {
    log('Executing GetAllTasksUseCase');
    try {
      final tasks = await repository.getTasks();
      log('Fetched ${tasks.length} tasks');
      return tasks;
    } catch (e, stackTrace) {
      log('Error in GetAllTasksUseCase: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
