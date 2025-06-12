// manage_task_view_model.dart
import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/set_hive_task.dart';

class ManageTaskViewModel extends ChangeNotifier {
  String? editingTaskId;

  String name = 'Empty';
  String description = 'Empty';
  Color color = Colors.primaries[
      DateTime.now().millisecondsSinceEpoch % Colors.primaries.length];

  DateTime startDate = DateTime.now().subtract(const Duration(minutes: 1));
  DateTime endDate = DateTime.now().copyWith(hour: 23, minute: 59);
  TimeOfDay startTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0);
  bool isAllDay = false;

  bool isRepeating = false;
  String repeatType = 'Daily';
  final List<String> repeatOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  int repeatInterval = 1;
  List<int> weeklyRepeatDays = [];
  List<int> monthlyRepeatDays = [];
  List<int> yearlyRepeatDays = [];

  String durationType = 'Forever';
  DateTime? durationDate;
  int? durationCount;

  String priority = 'No Priority';
  final List<String> priorityOptions = [
    'No Priority',
    'Low Priority',
    'Normal Priority',
    'High Priority'
  ];

  SetHiveTaskUseCase? _setTaskUseCase;

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setColor(Color value) {
    color = value;
    notifyListeners();
  }

  void setStartDate(DateTime value) {
    startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime value) {
    endDate = value;
    notifyListeners();
  }

  void setStartTime(TimeOfDay value) {
    startTime = value;
    final startDT = DateTime(startDate.year, startDate.month, startDate.day,
        startTime.hour, startTime.minute);
    final endDT = DateTime(
        endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
    if (!startDT.isBefore(endDT)) {
      final adjusted = startDT.add(const Duration(hours: 1));
      endTime = TimeOfDay(hour: adjusted.hour, minute: adjusted.minute);
      endDate = adjusted;
    }
    notifyListeners();
  }

  void setEndTime(TimeOfDay value) {
    endTime = value;
    notifyListeners();
  }

  void setAllDay(bool value) {
    isAllDay = value;
    notifyListeners();
  }

  void setRepeating(bool value) {
    isRepeating = value;
    notifyListeners();
  }

  void setRepeatType(String value) {
    repeatType = value;
    notifyListeners();
  }

  void setRepeatInterval(int value) {
    repeatInterval = value;
    notifyListeners();
  }

  void setWeeklyRepeatDays(List<int> days) {
    weeklyRepeatDays = days;
    notifyListeners();
  }

  void setMonthlyRepeatDays(List<int> days) {
    monthlyRepeatDays = days;
    notifyListeners();
  }

  void setYearlyRepeatDays(List<int> days) {
    yearlyRepeatDays = days;
    notifyListeners();
  }

  void setDurationType(String value) {
    durationType = value;
    if (value == 'Forever') {
      durationDate = null;
      durationCount = null;
    }
    notifyListeners();
  }

  void setDurationDate(DateTime? value) {
    durationDate = value;
    notifyListeners();
  }

  void setDurationCount(int? value) {
    durationCount = value;
    notifyListeners();
  }

  void setPriority(String value) {
    priority = value;
    notifyListeners();
  }

  void setTaskUseCase(SetHiveTaskUseCase useCase) {
    _setTaskUseCase = useCase;
  }

  void loadFromTask(Task task) {
    editingTaskId = task.id;
    name = task.title;
    description = task.description;
    color = task.color;
    startDate = task.startDate;
    endDate = task.endDate;
    isRepeating = task.recurrenceRule != null;
    isAllDay = task.isAllDay;
    if (!task.isAllDay) {
      startTime =
          TimeOfDay(hour: task.startDate.hour, minute: task.startDate.minute);
      endTime = TimeOfDay(hour: task.endDate.hour, minute: task.endDate.minute);
    }
    priority = task.priority;

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
        if (repeatOptions.contains(freq[0] + freq.substring(1).toLowerCase())) {
          repeatType = freq[0] + freq.substring(1).toLowerCase();
        } else {
          repeatType = repeatOptions.firstWhere((e) => e.toUpperCase() == freq,
              orElse: () => 'Daily');
        }
      }
      // INTERVAL
      if (parts.containsKey('INTERVAL')) {
        repeatInterval = int.tryParse(parts['INTERVAL']!) ?? 1;
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
        weeklyRepeatDays =
            parts['BYDAY']!.split(',').map((d) => map[d] ?? 1).toList();
      } else {
        weeklyRepeatDays = [];
      }
      // BYMONTHDAY (Monthly)
      if (parts.containsKey('BYMONTHDAY')) {
        monthlyRepeatDays = parts['BYMONTHDAY']!
            .split(',')
            .map((d) => int.tryParse(d) ?? 1)
            .toList();
      } else {
        monthlyRepeatDays = [];
      }
      // BYYEARDAY (Yearly)
      if (parts.containsKey('BYYEARDAY')) {
        yearlyRepeatDays = parts['BYYEARDAY']!
            .split(',')
            .map((d) => int.tryParse(d) ?? 1)
            .toList();
      } else {
        yearlyRepeatDays = [];
      }
      // UNTIL (Duration Type: Until)
      if (parts.containsKey('UNTIL')) {
        durationType = 'Until';
        try {
          durationDate = DateTime.parse(parts['UNTIL']!);
        } catch (_) {
          durationDate = null;
        }
        durationCount = null;
      } else if (parts.containsKey('COUNT')) {
        durationType = 'Count';
        durationCount = int.tryParse(parts['COUNT']!) ?? 1;
        durationDate = null;
      } else {
        durationType = 'Forever';
        durationDate = null;
        durationCount = null;
      }
    } else {
      // Reset recurrence fields if not repeating
      repeatType = 'Daily';
      repeatInterval = 1;
      weeklyRepeatDays = [];
      monthlyRepeatDays = [];
      yearlyRepeatDays = [];
      durationType = 'Forever';
      durationDate = null;
      durationCount = null;
    }

    notifyListeners();
  }

  Future<void> saveTask(BuildContext context) async {
    if (_setTaskUseCase == null) {
      throw Exception('SetHiveTaskUseCase not set');
    }
    final task = buildTask(recurrenceRule: generateRecurrenceRule());
    await _setTaskUseCase!.execute(task);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Task saved')));
    Navigator.pop(context);
  }

  Task buildTask({String? recurrenceRule}) {
    final DateTime start = isAllDay
        ? startDate
        : DateTime(startDate.year, startDate.month, startDate.day,
            startTime.hour, startTime.minute);
    final DateTime end = isAllDay
        ? endDate
        : DateTime(endDate.year, endDate.month, endDate.day, endTime.hour,
            endTime.minute);

    return Task(
      id: editingTaskId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: name,
      description: description,
      color: color,
      startDate: start,
      endDate: end,
      isAllDay: isAllDay,
      recurrenceRule: recurrenceRule,
      duration: durationType,
      priority: priority,
    );
  }

  String? generateRecurrenceRule() {
    if (!isRepeating) return null;
    const map = {1: 'MO', 2: 'TU', 3: 'WE', 4: 'TH', 5: 'FR', 6: 'SA', 7: 'SU'};
    final parts = [
      'FREQ=${repeatType.toUpperCase()}',
      'INTERVAL=$repeatInterval'
    ];
    if (repeatType == 'Weekly') {
      parts.add('BYDAY=${weeklyRepeatDays.map((d) => map[d]!).join(',')}');
    } else if (repeatType == 'Monthly') {
      parts.add('BYMONTHDAY=${monthlyRepeatDays.join(',')}');
    } else if (repeatType == 'Yearly') {
      parts.add('BYYEARDAY=${yearlyRepeatDays.join(',')}');
    }

    if (durationType == 'Until' && durationDate != null) {
      final until = durationDate!
          .toUtc()
          .add(const Duration(days: 1))
          .toIso8601String()
          .split('T')[0];
      parts.add('UNTIL=$until');
    } else if (durationType == 'Count' && durationCount != null) {
      parts.add('COUNT=$durationCount');
    }
    return 'RRULE:${parts.join(';')}';
  }
}
