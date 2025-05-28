import 'package:better_io/features/tasks/domain/entities/task.dart';
import '../../repositories/task_repository.dart';
import 'dart:developer';

class GetAllHiveTasksUseCase {
  final TaskRepository repository;

  GetAllHiveTasksUseCase(this.repository);

  Future<List<Task>> execute() async {
    try {
      final tasks = await repository.getTasks();
      List<Task> expandedTasks = [];
      for (var task in tasks) {
        final rule = task.recurrenceRule;
        if (rule != null && rule.contains('BYMONTHDAY=')) {
          final byMonthDayPart = RegExp(r'BYMONTHDAY=([^;]+)').firstMatch(rule);
          if (byMonthDayPart != null) {
            final daysStr = byMonthDayPart.group(1);
            final days = daysStr
                ?.split(',')
                .map((e) => int.tryParse(e))
                .where((e) => e != null)
                .toList();
            if (days!.length > 1) {
              for (var day in days) {
                var newRule = rule.replaceFirst(
                  RegExp(r'BYMONTHDAY=([^;]+)'),
                  'BYMONTHDAY=$day',
                );
                var newTask = task.copyWith(
                  recurrenceRule: newRule,
                );
                expandedTasks.add(newTask);
              }
              continue;
            }
          }
        }
        expandedTasks.add(task);
      }
      return expandedTasks;
    } catch (e, stackTrace) {
      log('Error in GetAllHiveTasksUseCase: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
