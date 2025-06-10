import '../entities/task.dart';

class TaskRecurrenceFixer {
  static List<Task> fix(List<Task> tasks) {
    List<Task> output = [];

    for (final task in tasks) {
      final rule = task.recurrenceRule;
      if (rule == null) {
        output.add(task);
        continue;
      }

      // Patch BYMONTHDAY (multiple days → split into separate tasks)
      if (rule.contains('BYMONTHDAY=')) {
        final match = RegExp(r'BYMONTHDAY=([\d,]+)').firstMatch(rule);
        if (match != null) {
          final days = match.group(1)!.split(',').map(int.parse).toList();
          if (days.length > 1) {
            for (final day in days) {
              final newRule = rule.replaceFirst(
                  RegExp(r'BYMONTHDAY=([\d,]+)'), 'BYMONTHDAY=$day');
              output.add(task.copyWith(recurrenceRule: newRule));
            }
            continue;
          }
        }
      }

      // Patch BYYEARDAY → to BYMONTHDAY and monthly
      if (rule.contains('BYYEARDAY=')) {
        final match = RegExp(r'BYYEARDAY=([\d,]+)').firstMatch(rule);
        if (match != null) {
          final days = match.group(1)!.split(',').map(int.parse).toList();
          if (days.length > 1) {
            for (final day in days) {
              final year = task.startDate.year;
              final date = DateTime(year).add(Duration(days: day - 1));
              final newRule = rule
                  .replaceFirst('FREQ=YEARLY;', 'FREQ=MONTHLY;INTERVAL=12;')
                  .replaceFirst(
                      RegExp(r'BYYEARDAY=([\d,]+)'), 'BYMONTHDAY=${date.day}');

              output.add(task.copyWith(
                recurrenceRule: newRule,
                startDate: date,
              ));
            }
            continue;
          }
        }
      }

      output.add(task); // default case
    }

    return output;
  }
}
