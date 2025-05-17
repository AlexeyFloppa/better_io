import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/helpers/repeat_helper.dart';
import '../../repositories/task_repository.dart';
import 'dart:developer';

/// Use case to fetch and process tasks by date with sorting and filtering.
class GetTasksByDateUseCase {
  final TaskRepository repository;
  final RepeatHelper repeatHelper;

  GetTasksByDateUseCase(this.repository, this.repeatHelper);

  /// Fetches tasks by date, sorts, filters, and limits them.
  Future<List<Task>> execute({
    DateTime? startDate,
    String? startTaskId,
    required int taskAmount,
  }) async {
    log('Executing GetTasksByDateUseCase with startDate=$startDate, startTaskId=$startTaskId, taskAmount=$taskAmount');
    try {
      final effectiveStartDate = startDate ?? DateTime.now();
      log('Effective start date: $effectiveStartDate');
      final originalTasks = await _fetchTasks();
      log('Original tasks fetched: ${originalTasks.length}');
      final taskDates = _processTasks(originalTasks, effectiveStartDate);
      log('Processed task dates: ${taskDates.length}');

      _sortTasks(taskDates);
      log('Tasks sorted');
      _removeTasksUpToMatch(taskDates, startTaskId, effectiveStartDate);
      log('Tasks removed up to match');

      final uniqueTaskDates = _removeDuplicateDates(taskDates);
      log('Unique task dates: ${uniqueTaskDates.length}');
      final limitedTasks = _limitTasks(uniqueTaskDates, taskAmount);
      log('Limited tasks: ${limitedTasks.length}');

      return _mapToResult(limitedTasks);
    } catch (e, stackTrace) {
      log('Error in GetTasksByDateUseCase: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Task>> _fetchTasks() async {
    final tasks = await repository.getTasks();
    log('Fetched ${tasks.length} tasks from repository');
    return tasks;
  }

  List<Map<String, dynamic>> _processTasks(List<Task> tasks, DateTime startDate) {
    log('Processing tasks with startDate=$startDate');
    final taskDates = <Map<String, dynamic>>[];

    for (final task in tasks) {
      if (task.isRecurring) {
        _processRecurringTask(task, startDate, taskDates);
      } else if (!task.startDate.isBefore(startDate)) {
        taskDates.add({
          'task': task,
          'date': task.startDate,
          'endDate': task.endDate,
        });
      }
    }

    return taskDates;
  }

  void _processRecurringTask(Task task, DateTime startDate, List<Map<String, dynamic>> taskDates) {
    final repeatRule = RepeatRule(
      type: _mapStringToRepeatType(task.recurrenceType),
      interval: task.recurrenceInterval,
      repeatPoints: task.recurrenceDays,
      startDate: task.startDate,
      endDate: task.endDate,
      endType: RepeatEndType.forever,
    );

    final repeatStartDates = repeatHelper.calculateRepeatStartDates(repeatRule);

    for (final date in repeatStartDates) {
      if (date.isAfter(startDate)) {
        taskDates.add({
          'task': task,
          'date': date,
          'endDate': date.add(task.endDate.difference(task.startDate)),
        });
      }
    }
  }

  void _sortTasks(List<Map<String, dynamic>> taskDates) {
    log('Sorting tasks');
    taskDates.sort((a, b) {
      final dateComparison = (a['date'] as DateTime).compareTo(b['date'] as DateTime);
      if (dateComparison != 0) return dateComparison;
      return (a['task'] as Task).title.compareTo((b['task'] as Task).title);
    });
  }

  void _removeTasksUpToMatch(
      List<Map<String, dynamic>> taskDates, String? startTaskId, DateTime startDate) {
    log('Removing tasks up to match with startTaskId=$startTaskId, startDate=$startDate');
    if (startTaskId == null) return;

    int indexToRemove = -1;
    for (int i = 0; i < taskDates.length; i++) {
      final task = taskDates[i]['task'] as Task;
      final date = taskDates[i]['date'] as DateTime;
      if (task.id == startTaskId && date == startDate) {
        indexToRemove = i;
        break;
      }
    }

    if (indexToRemove != -1) {
      taskDates.removeRange(0, indexToRemove + 1);
    }
  }

  Map<DateTime, Map<String, dynamic>> _removeDuplicateDates(List<Map<String, dynamic>> taskDates) {
    final uniqueTaskDates = <DateTime, Map<String, dynamic>>{};
    for (final entry in taskDates) {
      final date = entry['date'] as DateTime;
      uniqueTaskDates.putIfAbsent(date, () => entry);
    }
    return uniqueTaskDates;
  }

  List<Map<String, dynamic>> _limitTasks(
      Map<DateTime, Map<String, dynamic>> uniqueTaskDates, int taskAmount) {
    return uniqueTaskDates.values.take(taskAmount).toList();
  }

  List<Task> _mapToResult(List<Map<String, dynamic>> taskEntries) {
    return taskEntries.map((entry) {
      final task = entry['task'] as Task;
      return Task(
        id: task.id,
        title: task.title,
        description: task.description,
        color: task.color,
        startDate: entry['date'] as DateTime,
        endDate: entry['endDate'] as DateTime,
        isAllDay: task.isAllDay,
        isRecurring: task.isRecurring,
        recurrenceType: task.recurrenceType,
        recurrenceInterval: task.recurrenceInterval,
        recurrenceDays: task.recurrenceDays,
        duration: task.duration,
        priority: task.priority,
      );
    }).toList();
  }

  RepeatType _mapStringToRepeatType(String recurrenceType) {
    switch (recurrenceType.toLowerCase()) {
      case 'hourly':
        return RepeatType.hourly;
      case 'daily':
        return RepeatType.daily;
      case 'weekly':
        return RepeatType.weekly;
      case 'monthly':
        return RepeatType.monthly;
      case 'yearly':
        return RepeatType.yearly;
      case 'custom':
        return RepeatType.custom;
      default:
        throw ArgumentError('Invalid recurrence type: $recurrenceType');
    }
  }
}