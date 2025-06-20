import 'package:better_io/features/tasks/domain/entities/task.dart';
import '../../repositories/task_repository.dart';

class DeleteHiveRecurrencyUseCase {
  final TaskRepository repository;

  DeleteHiveRecurrencyUseCase(this.repository);

  Future<void> execute(String id, DateTime recurrenceDate) async {
    final Task task = await repository.getTask(id);

    final Task updatedTask = task.copyWith(
      recurrenceExceptionDates: [
        ...?task.recurrenceExceptionDates,
        recurrenceDate,
      ],

    );
    await repository.setTask(updatedTask);

  }
}
