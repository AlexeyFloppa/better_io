// manage_task_view_model.dart
import 'package:flutter/material.dart';

class RecurrenceBlockModel extends ChangeNotifier {
  // --- Repeat/Recurrence Fields ---
  bool isRepeating = false;
  String repeatType = 'Daily';
  final List<String> repeatOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  int repeatInterval = 1;
  List<int> weeklyRepeatDays = [];
  List<int> monthlyRepeatDays = [];
  List<int> yearlyRepeatDays = [];

  // --- Duration Fields ---
  String durationType = 'Forever';
  DateTime? durationDate;
  int? durationCount;

  // --- Setters for Repeat/Recurrence ---
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
