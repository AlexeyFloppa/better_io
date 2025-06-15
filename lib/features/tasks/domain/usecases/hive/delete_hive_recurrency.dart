import 'dart:developer';

import 'package:better_io/features/tasks/domain/entities/task.dart';
import '../../repositories/task_repository.dart';

class DeleteHiveRecurrencyUseCase {
  final TaskRepository repository;

  DeleteHiveRecurrencyUseCase(this.repository);

  Future<void> execute(String id, DateTime recurrenceDate) async {
    final Task task = await repository.getTask(id);

    final String exdateToAdd = _formatICalUtc(recurrenceDate);

    String newRecurrenceRule;
    if (task.recurrenceRule != null &&
        task.recurrenceRule!.contains(';EXDATE=')) {
      // EXDATE exists, append new date with comma
      final exdateRegex = RegExp(r';EXDATE=([^;]*)');
      final match = exdateRegex.firstMatch(task.recurrenceRule!);
      if (match != null) {
        final existingExdates = match.group(1)!;
        // Avoid duplicate EXDATE
        final exdateList = existingExdates.split(',');
        if (!exdateList.contains(exdateToAdd)) {
          final updatedExdates = '$existingExdates,$exdateToAdd';
          newRecurrenceRule = task.recurrenceRule!.replaceFirst(
            ';EXDATE=$existingExdates',
            ';EXDATE=$updatedExdates',
          );
        } else {
          newRecurrenceRule = task.recurrenceRule!;
        }
      } else {
        // Should not happen, but fallback
        newRecurrenceRule = '${task.recurrenceRule!};EXDATE=$exdateToAdd';
      }
    } else {
      // No EXDATE, add new
      newRecurrenceRule = '${task.recurrenceRule!};EXDATE=$exdateToAdd';
    }

    final Task updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      color: task.color,
      startDate: task.startDate,
      endDate: task.endDate,
      isAllDay: task.isAllDay,
      recurrenceRule:
          newRecurrenceRule.trim().isEmpty ? null : newRecurrenceRule,
      duration: task.duration,
      priority: task.priority,
      category: task.category,
    );
    log("newRecurrenceRule: $newRecurrenceRule");
    log("newRecurrenceRule.trim(): ${newRecurrenceRule.trim()}");
    log("GetHiveRecurrencyUseCase: ${updatedTask.recurrenceRule}");

    await repository.setTask(updatedTask);
  }

  String _formatICalUtc(DateTime date) {
    final d = date.toUtc();
    return '${d.year.toString().padLeft(4, '0')}'
        '${d.month.toString().padLeft(2, '0')}'
        '${d.day.toString().padLeft(2, '0')}T'
        '${d.hour.toString().padLeft(2, '0')}'
        '${d.minute.toString().padLeft(2, '0')}'
        '${d.second.toString().padLeft(2, '0')}Z';
  }
}
