class TaskRepeat {
  /// Generates a list of task dates based on the repeat configuration.
  List<DateTime> generateTaskDates(
    DateTime startDate, String repeatType, int repeatInterval, List<int> repeatDays, DateTime durationDate) {
    List<DateTime> taskDateList = [];
    if (repeatType == 'Daily') {
      _generateDailyDates(startDate, repeatInterval, durationDate, taskDateList);
    } else if (repeatType == 'Weekly') {
      _generateWeeklyDates(startDate, repeatInterval, repeatDays, durationDate, taskDateList);
    } else if (repeatType == 'Monthly') {
      _generateMonthlyDates(startDate, repeatInterval, repeatDays, durationDate, taskDateList);
    }
    return taskDateList;
  }

  DateTime generateTaskDate(
    DateTime startDate, String repeatType, int repeatInterval, List<int> repeatDays, DateTime durationDate) {
    if (repeatType == 'Daily') {
      return startDate.add(Duration(days: repeatInterval));
    } else if (repeatType == 'Weekly') {
      for (int i = 1; i <= 7; i++) {
        DateTime potentialDate = startDate.add(Duration(days: i));
        if (repeatDays.contains(potentialDate.weekday)) {
          return potentialDate;
        }
      }
    } else if (repeatType == 'Monthly') {
      for (int day in repeatDays) {
        try {
          DateTime potentialDate = DateTime(
            startDate.year,
            startDate.month + repeatInterval,
            day,
            startDate.hour,
            startDate.minute,
            startDate.second,
            startDate.millisecond,
          );
          if (potentialDate.isAfter(startDate)) {
            return potentialDate;
          }
        } catch (e) {
          continue; // Ignore invalid dates (e.g., February 30th)
        }
      }
    }
    return startDate; // Default to the start date if no valid date is found
  }

  /// Calculates the end date based on the repeat configuration and duration.
  DateTime generateDurationDate(
      DateTime startDate, String repeatType, int repeatInterval, List<int> repeatDays, String duration) {
    
    if (int.tryParse(duration) != null) {
      int durationAmount = int.parse(duration);
      return _calculateDurationDate(startDate, repeatType, repeatInterval, repeatDays, durationAmount);
    }
    else if (duration == 'Forever') {
      return DateTime(9999, 12, 31); // Arbitrary far future date
    }

    return DateTime.parse(duration);
  }
  /// Generates daily task dates based on the repeat interval.
  void _generateDailyDates(
      DateTime startDate, int repeatInterval, DateTime durationDate, List<DateTime> taskDateList, [int? amount]) {
    taskDateList.add(startDate);
    while (taskDateList.last.add(Duration(days: repeatInterval)).isBefore(durationDate)) {
      if (amount != null && taskDateList.length >= amount) break;
      taskDateList.add(taskDateList.last.add(Duration(days: repeatInterval)));
    }
  }

  /// Generates weekly task dates based on the repeat interval and days of the week.
  void _generateWeeklyDates(DateTime startDate, int repeatInterval, List<int> repeatDays, DateTime durationDate,
      List<DateTime> taskDateList, [int? amount]) {
    DateTime currentDate = startDate;
    while (currentDate.isBefore(durationDate) || currentDate.isAtSameMomentAs(durationDate)) {
      if (amount != null && taskDateList.length >= amount) break;
      DateTime weekStart = currentDate.subtract(Duration(days: currentDate.weekday - 1)); // Start of the week (Monday)
      for (int i = 0; i < 7; i++) {
        if (amount != null && taskDateList.length >= amount) break;
        DateTime checkDate = weekStart.add(Duration(days: i));
        if (_isValidWeeklyDate(checkDate, startDate, durationDate, repeatDays)) {
          taskDateList.add(_adjustTime(checkDate, startDate));
        }
      }
      currentDate = weekStart.add(Duration(days: repeatInterval * 7)); // Move to the next valid week
    }
  }

  /// Generates monthly task dates based on the repeat interval and specific days.
  void _generateMonthlyDates(DateTime startDate, int repeatInterval, List<int> repeatDays, DateTime durationDate,
      List<DateTime> taskDateList, [int? amount]) {
    DateTime currentDate = startDate;
    while (currentDate.isBefore(durationDate) || currentDate.isAtSameMomentAs(durationDate)) {
      if (amount != null && taskDateList.length >= amount) break;
      for (int day in repeatDays) {
        if (amount != null && taskDateList.length >= amount) break;
        try {
          DateTime checkDate = DateTime(currentDate.year, currentDate.month, day, startDate.hour, startDate.minute,
              startDate.second, startDate.millisecond);
          if (checkDate.isAfter(startDate) && checkDate.isBefore(durationDate)) {
            taskDateList.add(checkDate);
          }
        } catch (e) {
          continue; // Ignore invalid dates (e.g., February 30th)
        }
      }
      currentDate = _moveToNextMonth(currentDate, repeatInterval);
    }
  }

  /// Calculates the duration date based on the repeat configuration and duration amount.
  DateTime _calculateDurationDate(DateTime startDate, String repeatType, int repeatInterval, List<int> repeatDays,
      int durationAmount) {
    List<DateTime> taskDateList = [];
    if (repeatType == 'Daily') {
      _generateDailyDates(startDate, repeatInterval, startDate.add(Duration(days: durationAmount * repeatInterval)),
          taskDateList);
    } else if (repeatType == 'Weekly') {
      _generateWeeklyDates(startDate, repeatInterval, repeatDays,
          startDate.add(Duration(days: durationAmount * repeatInterval * 7)), taskDateList);
    } else if (repeatType == 'Monthly') {
      _generateMonthlyDates(startDate, repeatInterval, repeatDays,
          startDate.add(Duration(days: durationAmount * 30)), taskDateList);
    }
    return taskDateList.isNotEmpty ? taskDateList.last : startDate;
  }

  /// Checks if a weekly date is valid based on the repeat configuration.
  bool _isValidWeeklyDate(DateTime checkDate, DateTime startDate, DateTime durationDate, List<int> repeatDays) {
    return repeatDays.contains(checkDate.weekday) &&
        checkDate.isAfter(startDate) &&
        checkDate.isBefore(durationDate);
  }

  /// Adjusts the time of a date to match the start date's time.
  DateTime _adjustTime(DateTime date, DateTime startDate) {
    return DateTime(date.year, date.month, date.day, startDate.hour, startDate.minute, startDate.second,
        startDate.millisecond);
  }

  /// Moves to the next valid month based on the repeat interval.
  DateTime _moveToNextMonth(DateTime currentDate, int repeatInterval) {
    int nextMonth = currentDate.month + repeatInterval;
    int nextYear = currentDate.year + (nextMonth - 1) ~/ 12;
    nextMonth = (nextMonth - 1) % 12 + 1;
    return DateTime(nextYear, nextMonth, 1);
  }
}
