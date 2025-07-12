// manage_task_view_model.dart
import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/basic_block_model.dart';
import 'package:better_io/features/tasks/presentation/task_management/view_models/block_models/recurrence_block_model.dart';
import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/task/set_task.dart';

// FeedbackEntry model for multi-feedback support
class FeedbackEntry {
  String? type;
  String? label;
  String? instruction;
  FeedbackEntry({this.type, this.label, this.instruction});
}

class ManageTaskViewModel extends ChangeNotifier {
  BasicBlockModel basicBm = BasicBlockModel();
  RecurrenceBlockModel recurrenceBm = RecurrenceBlockModel();

  // --- Task Identity & Basic Fields ---
  String? editingTaskId;
  // --- Use Case ---
  SetTaskUseCase? _setTaskUseCase;

  // --- Set Use Case ---
  void setTaskUseCase(SetTaskUseCase useCase) {
    _setTaskUseCase = useCase;
  }

  // --- Task Loading & Saving ---
  void loadFromTask(Task task) {
    editingTaskId = task.id;
    basicBm.name = task.title;
    basicBm.description = task.description;
    basicBm.color = task.color;
    basicBm.startDate = task.startDate;
    basicBm.endDate = task.endDate;
    recurrenceBm.isRepeating = task.recurrenceRule != null;
    basicBm.isAllDay = task.isAllDay;
    if (!task.isAllDay) {
      basicBm.startTime =
          TimeOfDay(hour: task.startDate.hour, minute: task.startDate.minute);
      basicBm.endTime =
          TimeOfDay(hour: task.endDate.hour, minute: task.endDate.minute);
    }
    basicBm.priority = task.priority;
    basicBm.category = task.category;

    // Parse recurrence rule if present
    if (task.recurrenceRule != null) {
      final rule = task.recurrenceRule!;
      final rrule = rule.startsWith('RRULE:') ? rule.substring(6) : rule;
      final parts = <String, String>{};
      for (final part in rrule.split(';')) {
        final idx = part.indexOf('=');
        if (idx > 0) {
          parts[part.substring(0, idx)] = part.substring(idx + 1);
        }
      }
      // FREQ
      if (parts.containsKey('FREQ')) {
        final freq = parts['FREQ']!;
        if (recurrenceBm.repeatOptions
            .contains(freq[0] + freq.substring(1).toLowerCase())) {
          recurrenceBm.repeatType = freq[0] + freq.substring(1).toLowerCase();
        } else {
          recurrenceBm.repeatType = recurrenceBm.repeatOptions.firstWhere(
              (e) => e.toUpperCase() == freq,
              orElse: () => 'Daily');
        }
      }
      // INTERVAL
      if (parts.containsKey('INTERVAL')) {
        recurrenceBm.repeatInterval = int.tryParse(parts['INTERVAL']!) ?? 1;
      }
      // BYDAY (Weekly)
      if (parts.containsKey('BYDAY')) {
        final map = {
          'MO': 1,
          'TU': 2,
          'WE': 3,
          'TH': 4,
          'FR': 5,
          'SA': 6,
          'SU': 7
        };
        recurrenceBm.weeklyRepeatDays =
            parts['BYDAY']!.split(',').map((d) => map[d] ?? 1).toList();
      } else {
        recurrenceBm.weeklyRepeatDays = [];
      }
      // BYMONTHDAY (Monthly)
      if (parts.containsKey('BYMONTHDAY')) {
        recurrenceBm.monthlyRepeatDays = parts['BYMONTHDAY']!
            .split(',')
            .map((d) => int.tryParse(d) ?? 1)
            .toList();
      } else {
        recurrenceBm.monthlyRepeatDays = [];
      }
      // BYYEARDAY (Yearly)
      if (parts.containsKey('BYYEARDAY')) {
        recurrenceBm.yearlyRepeatDays = parts['BYYEARDAY']!
            .split(',')
            .map((d) => int.tryParse(d) ?? 1)
            .toList();
      } else {
        recurrenceBm.yearlyRepeatDays = [];
      }
      // UNTIL (Duration Type: Until)
      if (parts.containsKey('UNTIL')) {
        recurrenceBm.durationType = 'Until';
        try {
          recurrenceBm.durationDate = DateTime.parse(parts['UNTIL']!);
        } catch (_) {
          recurrenceBm.durationDate = null;
        }
        recurrenceBm.durationCount = null;
      } else if (parts.containsKey('COUNT')) {
        recurrenceBm.durationType = 'Count';
        recurrenceBm.durationCount = int.tryParse(parts['COUNT']!) ?? 1;
        recurrenceBm.durationDate = null;
      } else {
        recurrenceBm.durationType = 'Forever';
        recurrenceBm.durationDate = null;
        recurrenceBm.durationCount = null;
      }
    } else {
      // Reset recurrence fields if not repeating
      recurrenceBm.repeatType = 'Daily';
      recurrenceBm.repeatInterval = 1;
      recurrenceBm.weeklyRepeatDays = [];
      recurrenceBm.monthlyRepeatDays = [];
      recurrenceBm.yearlyRepeatDays = [];
      recurrenceBm.durationType = 'Forever';
      recurrenceBm.durationDate = null;
      recurrenceBm.durationCount = null;
    }

    notifyListeners();
  }

  Future<void> saveTask(BuildContext context) async {
    if (_setTaskUseCase == null) {
      throw Exception('SetTaskUseCase not set');
    }

    final recurrenceRule =
        recurrenceBm.isRepeating ? recurrenceBm.generateRecurrenceRule() : null;

    final task = buildTask(recurrenceRule: recurrenceRule);
    await _setTaskUseCase!.execute(task);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Task saved')));
    Navigator.pop(context);
  }

  Task buildTask({String? recurrenceRule}) {
    final DateTime start = basicBm.isAllDay
        ? basicBm.startDate
        : DateTime(
            basicBm.startDate.year,
            basicBm.startDate.month,
            basicBm.startDate.day,
            basicBm.startTime.hour,
            basicBm.startTime.minute);
    final DateTime end = basicBm.isAllDay
        ? basicBm.endDate
        : DateTime(basicBm.endDate.year, basicBm.endDate.month,
            basicBm.endDate.day, basicBm.endTime.hour, basicBm.endTime.minute);

    // Calculate proper duration
    final duration = end.difference(start);
    final durationString = basicBm.isAllDay
        ? 'All Day'
        : '${duration.inHours}h ${duration.inMinutes % 60}m';

    return Task(
      id: editingTaskId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: basicBm.name,
      description: basicBm.description,
      color: basicBm.color,
      startDate: start,
      endDate: end,
      isAllDay: basicBm.isAllDay,
      recurrenceRule: recurrenceRule,
      duration: durationString,
      priority: basicBm.priority,
      category: basicBm.category,
    );
  }
}
