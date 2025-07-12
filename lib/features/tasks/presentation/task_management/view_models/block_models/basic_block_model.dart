// manage_task_view_model.dart
import 'package:better_io/features/tasks/domain/entities/task_category.dart';
import 'package:better_io/features/tasks/domain/entities/task_priority.dart';
import 'package:flutter/material.dart';

class BasicBlockModel extends ChangeNotifier {
  // --- Basic Fields ---
  String name = 'Empty';
  String description = 'Empty';
  Color color = Colors.primaries[
      DateTime.now().millisecondsSinceEpoch % Colors.primaries.length];

  // --- Date & Time Fields ---
  DateTime startDate = DateTime.now().copyWith(hour: 0, minute: 0);
  DateTime endDate = DateTime.now().copyWith(hour: 23, minute: 59);
  TimeOfDay startTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0);

  bool isAllDay = false;

  // --- Category & Priority ---
  TaskCategory category = TaskCategory.general; // Default category
  final List<TaskCategory> categoryOptions = TaskCategory.values;

  TaskPriority priority = TaskPriority.none; // Default priority
  final List<TaskPriority> priorityOptions = TaskPriority.values;

  // --- Setters for Basic Fields ---
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

  // --- Setters for Category & Priority ---
  void setCategory(TaskCategory value) {
    category = value;
    notifyListeners();
  }

  void setPriority(TaskPriority value) {
    priority = value;
    notifyListeners();
  }
}
