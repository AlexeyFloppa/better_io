import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_all_hive_tasks.dart';
import 'package:better_io/features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';

class CalendarsViewModel extends ChangeNotifier {
  final GetAllHiveTasksUseCase _getAllTasksUseCase;
  List<Appointment> _appointments = [];
  List<Task> _tasks = [];
  bool _isLoading = true;

  CalendarsViewModel._(this._getAllTasksUseCase) {
    loadTasks();
  }

  factory CalendarsViewModel() {
    final taskBox = Hive.box<HiveTaskModel>('tasks');
    final repository = HiveTaskRepository(taskBox);
    return CalendarsViewModel._(GetAllHiveTasksUseCase(repository));
  }

  List<Task> get tasks => _tasks; 

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<Task> _tasks = await _getAllTasksUseCase.execute();

    

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
      _appointments = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
