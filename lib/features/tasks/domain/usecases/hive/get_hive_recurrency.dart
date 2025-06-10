import 'package:better_io/features/tasks/domain/entities/task.dart';
import '../../repositories/task_repository.dart';
import 'dart:developer';

class GetHiveRecurrencyUseCase {
  final TaskRepository repository;
  final String id; // <-- change int to String

  GetHiveRecurrencyUseCase(this.repository, this.id);

  Future<Task> execute() async {
    try {
      final task = await repository.getTask(id); // <-- pass String id
      return task;
    } catch (e, stackTrace) {
      log("Error in  GetHiveRecurrencyUseCase: $e", stackTrace: stackTrace);
      rethrow;
    }
  }
}
