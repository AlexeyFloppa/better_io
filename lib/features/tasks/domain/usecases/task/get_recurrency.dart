import 'package:better_io/features/tasks/domain/entities/task.dart';
import '../../repositories/task_repository.dart';
import 'dart:developer';

class GetRecurrencyUseCase {
  final ITaskRepository repository;
  final String id; // <-- change int to String

  GetRecurrencyUseCase(this.repository, this.id);

  Future<Task> execute() async {
    try {
      final task = await repository.getTask(id); // <-- pass String id
      return task;
    } catch (e, stackTrace) {
      log("Error in  GetRecurrencyUseCase: $e", stackTrace: stackTrace);
      rethrow;
    }
  }
}
