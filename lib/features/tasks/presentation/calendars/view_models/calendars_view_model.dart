import 'dart:developer';
import 'package:better_io/features/tasks/data/models/task_model.dart';
import 'package:better_io/features/tasks/data/repositories/task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/task/delete_task.dart';
import 'package:better_io/features/tasks/domain/usecases/task/delete_recurrency.dart';

import 'package:better_io/features/tasks/domain/usecases/task/get_all_tasks.dart';
import 'package:better_io/features/tasks/domain/usecases/task/get_recurrence.dart';
import 'package:better_io/features/tasks/presentation/task_management/views/manage_task_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarsViewModel extends ChangeNotifier {
  final GetAllTasksUseCase _getAllTasksUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final DeleteRecurrenceUseCase _deleteRecurrenceUseCase;

  List<Appointment> _appointments = [];
  List<Task> _tasks = [];
  bool _isLoading = true;

  CalendarsViewModel._(
    this._getAllTasksUseCase,
    this._deleteTaskUseCase,
    this._deleteRecurrenceUseCase,
  ) {
    loadTasks();
  }

  factory CalendarsViewModel() {
    final taskBox = Hive.box<TaskModel>('tasks');
    final repository = TaskRepository(taskBox);

    return CalendarsViewModel._(
      GetAllTasksUseCase(repository),
      DeleteTaskUseCase(repository),
      DeleteRecurrenceUseCase(repository),
    );
  }

  List<Task> get tasks => _tasks;
  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _getAllTasksUseCase.execute();

      _appointments = _tasks.map((task) {
        return Appointment(
          id: task.id,
          startTime: task.startDate,
          endTime: task.endDate,
          isAllDay: task.isAllDay,
          subject: task.title,
          notes: task.description,
          color: task.color,
          recurrenceRule: task.recurrenceRule,
          recurrenceExceptionDates: task.recurrenceExceptionDates,
        );
      }).toList();
    } catch (e, stack) {
      log("Error loading tasks: $e", stackTrace: stack);
      _tasks = [];
      _appointments = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _deleteTaskUseCase.execute(id);
    await loadTasks();
  }

  Future<void> editTask(BuildContext context, String id) async {
    try {
      final navigator = Navigator.of(context);
      final taskBox = Hive.box<TaskModel>('tasks');
      final repository = TaskRepository(taskBox);
      final getRecurrenceUseCase = GetRecurrenceUseCase(repository, id);
      final Task task = await getRecurrenceUseCase.execute();

      // Navigate to ManageTaskScreen in edit mode
      await navigator.push(
        MaterialPageRoute(
          builder: (_) => ManageTaskView(task: task),
        ),
      );
      // Optionally reload tasks after editing
      await loadTasks();
    } catch (e, stack) {
      log("Error editing task: $e", stackTrace: stack);
    }
  }

  Future<void> deleteRecurrence(String id, DateTime recurrenceDate) async {
    await _deleteRecurrenceUseCase.execute(id, recurrenceDate);
    await loadTasks();
  }
}
