import 'package:flutter/material.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';

class ManageTaskViewModel extends ChangeNotifier {
  String taskName = 'Empty';
  String taskDescription = 'Empty';
  Color taskColor = Colors.primaries[DateTime.now().millisecondsSinceEpoch % Colors.primaries.length];

  DateTime startDate = DateTime.now().subtract(const Duration(minutes: 1));
  DateTime endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59);
  TimeOfDay startTime = TimeOfDay(hour: TimeOfDay.now().hour, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
  bool isAllDay = false;
  bool isRepeating = false;
  String repeatType = 'Daily';
  final List<String> repeatOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  int repeatInterval = 1;
  List<int> weeklyRepeatDays = [];
  List<int> monthlyRepeatDays = [];
  List<int> yearlyRepeatDays = [];

  String durationType = 'Forever';
  DateTime? durationDate;
  int? durationAmount;

  void setTaskName(String value) {
    taskName = value;
    notifyListeners();
  }

  void setTaskDescription(String value) {
    taskDescription = value;
    notifyListeners();
  }

  void setTaskColor(Color value) {
    taskColor = value;
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
    if (durationType == 'Forever') {
      durationDate = null;
      durationAmount = null;
    }
    notifyListeners();
  }

  void setDurationDate(DateTime? value) {
    durationDate = value;
    notifyListeners();
  }

  void setDurationAmount(int? value) {
    durationAmount = value;
    notifyListeners();
  }

  Task buildTask() {
    // You can add recurrenceRule logic here if needed
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: taskName,
      description: taskDescription,
      color: Colors.blue,
      startDate: !isAllDay
          ? DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
              startTime.hour,
              startTime.minute,
            )
          : startDate,
      endDate: !isAllDay
          ? DateTime(
              endDate.year,
              endDate.month,
              endDate.day,
              endTime.hour,
              endTime.minute,
            )
          : endDate,
      isAllDay: isAllDay,
      recurrenceRule: null, // Add logic if needed
      duration: durationType,
      priority: 'No Priority',
    );
  }
}
