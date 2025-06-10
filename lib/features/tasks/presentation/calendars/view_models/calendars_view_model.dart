import 'dart:developer';
import 'package:better_io/features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/delete_hive_task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_all_hive_tasks.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_hive_recurrency.dart';
import 'package:better_io/features/tasks/presentation/manage_task/screens/manage_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarsViewModel extends ChangeNotifier {
  final GetAllHiveTasksUseCase _getAllTasksUseCase;
  final DeleteHiveTaskUseCase _deleteHiveTaskUseCase;

  List<Appointment> _appointments = [];
  List<Task> _tasks = [];
  bool _isLoading = true;

  CalendarsViewModel._(
    this._getAllTasksUseCase,
    this._deleteHiveTaskUseCase,
  ) {
    loadTasks();
  }

  factory CalendarsViewModel() {
    final taskBox = Hive.box<HiveTaskModel>('tasks');
    final repository = HiveTaskRepository(taskBox);

    return CalendarsViewModel._(
      GetAllHiveTasksUseCase(repository),
      DeleteHiveTaskUseCase(repository),
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
    await _deleteHiveTaskUseCase.execute(id);
    await loadTasks();
  }

  Future<void> editTask(BuildContext context, String id) async {
    try {
      final navigator = Navigator.of(context);
      final taskBox = Hive.box<HiveTaskModel>('tasks');
      final repository = HiveTaskRepository(taskBox);
      final getTaskUseCase = GetHiveRecurrencyUseCase(repository, id);
      final Task task = await getTaskUseCase.execute();

      // Navigate to ManageTaskScreen in edit mode
      await navigator.push(
        MaterialPageRoute(
          builder: (_) => ManageTaskScreen(task: task),
        ),
      );
      // Optionally reload tasks after editing
      await loadTasks();
    } catch (e, stack) {
      log("Error editing task: $e", stackTrace: stack);
    }
  }
}
