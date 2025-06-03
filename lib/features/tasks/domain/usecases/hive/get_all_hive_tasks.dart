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
        } else if (rule != null && rule.contains("BYYEARDAY=")) {
          final byYearDayPart = RegExp(r'BYYEARDAY=([^;]+)').firstMatch(rule);
          if (byYearDayPart != null) {
            final daysStr = byYearDayPart.group(1);
            final days = daysStr
                ?.split(',')
                .map((e) => int.tryParse(e))
                .where((e) => e != null)
                .toList();
            if (days!.length > 1) {
              for (var day in days) {
                final year = task.startDate.year;
                final date = DateTime(year).add(Duration(days: day! - 1));
                final freqIntervalReg = RegExp(r'FREQ=YEARLY;INTERVAL=(\d+);');
                final match = freqIntervalReg.firstMatch(rule);
                var newRule = rule;
                if (match != null) {
                  final oldInterval = int.parse(match.group(1)!);
                  final newInterval = 12 * oldInterval;
                  newRule = rule.replaceFirst(
                    freqIntervalReg,
                    'FREQ=MONTHLY;INTERVAL=$newInterval;',
                  );
                }
                newRule = newRule.replaceFirst(
                  RegExp(r'BYYEARDAY=([^;]+;?)'),
                  'BYMONTHDAY=${date.day};',
                );

                var newTask = task.copyWith(
                  recurrenceRule: newRule,
                  startDate: date,
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
      log("Error in GetAllHiveTasksUseCase: $e", stackTrace: stackTrace);
      rethrow;
    }
  }
}
