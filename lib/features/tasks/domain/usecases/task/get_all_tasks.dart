import 'package:better_io/features/tasks/domain/entities/task.dart';
// import 'package:better_io/features/tasks/domain/helpers/recurrence_exdate_filter.dart';
import 'package:better_io/features/tasks/domain/helpers/task_recurrence_fixer.dart';
import '../../repositories/task_repository.dart';

import 'dart:developer';

class GetAllTasksUseCase {
  final ITaskRepository repository;

  GetAllTasksUseCase(this.repository);

  Future<List<Task>> execute() async {
    try {
      final rawTasks = await repository.getTasks();
      final fixedTasks = TaskRecurrenceFixer.fix(rawTasks);
      return fixedTasks;
      // final cleanedTasks = RecurrenceExDateFilter.filterTasks(fixedTasks);
      // return cleanedTasks;
    } catch (e, stackTrace) {
      log("Error in GetAllTasksUseCase: $e", stackTrace: stackTrace);
      rethrow;
    }
  }
}
