// Enums & Models

enum RepeatType { hourly, daily, weekly, monthly, yearly, custom }

enum RepeatEndType { forever, untilDate, count }

class RepeatRule {
  final RepeatType type;
  final int interval;
  final List<int>? repeatPoints;
  final DateTime startDate;
  final DateTime endDate;
  final RepeatEndType endType;
  final DateTime? untilDate;
  final int? maxOccurrences;

  RepeatRule({
    required this.type,
    required this.interval,
    this.repeatPoints,
    required this.startDate,
    required this.endDate,
    required this.endType,
    this.untilDate,
    this.maxOccurrences,
  });
}

class TimeRange {
  final DateTime start;
  final DateTime end;

  TimeRange({required this.start, required this.end});
}

class RepeatHelper {
  List<DateTime> calculateRepeatStartDates(RepeatRule rule) {
    final List<DateTime> startDates = [];
    DateTime currentStart = rule.startDate;

    bool isValidDate(int year, int month, int day) {
      try {
        DateTime test = DateTime(year, month, day);
        return test.month == month && test.day == day;
      } catch (_) {
        return false;
      }
    }

    bool shouldStop(DateTime date, int count) {
      if (rule.endType == RepeatEndType.untilDate && date.isAfter(rule.untilDate!)) return true;
      if (rule.endType == RepeatEndType.count && count >= (rule.maxOccurrences ?? 1)) return true;
      if (rule.endType == RepeatEndType.forever && count >= 1000) return true;
      return false;
    }

    while (true) {
      if (shouldStop(currentStart, startDates.length)) break;

      switch (rule.type) {
        case RepeatType.hourly:
          startDates.add(currentStart);
          currentStart = currentStart.add(Duration(hours: rule.interval));
          break;

        case RepeatType.daily:
          startDates.add(currentStart);
          currentStart = currentStart.add(Duration(days: rule.interval));
          break;

        case RepeatType.weekly:
          DateTime baseWeekStart = currentStart.subtract(Duration(days: currentStart.weekday - 1));
          for (int weekday in rule.repeatPoints ?? []) {
            final int offset = (weekday - 1);
            final DateTime occurrenceDate = baseWeekStart.add(Duration(days: offset));
            if (occurrenceDate.isBefore(rule.startDate)) continue;
            if (shouldStop(occurrenceDate, startDates.length)) break;
            if (!startDates.contains(occurrenceDate)) startDates.add(occurrenceDate);
          }
          currentStart = baseWeekStart.add(Duration(days: 7 * rule.interval));
          break;

        case RepeatType.monthly:
          final DateTime monthBase = currentStart;
          for (int day in rule.repeatPoints ?? []) {
            if (isValidDate(monthBase.year, monthBase.month, day)) {
              final DateTime occurrenceDate = DateTime(monthBase.year, monthBase.month, day);
              if (occurrenceDate.isBefore(rule.startDate)) continue;
              if (shouldStop(occurrenceDate, startDates.length)) break;
              if (!startDates.contains(occurrenceDate)) startDates.add(occurrenceDate);
            }
          }
          currentStart = DateTime(currentStart.year, currentStart.month + rule.interval, 1);
          break;

        case RepeatType.yearly:
          for (int point in rule.repeatPoints ?? []) {
            final int month = point ~/ 100;
            final int day = point % 100;
            if (isValidDate(currentStart.year, month, day)) {
              final DateTime occurrenceDate = DateTime(currentStart.year, month, day);
              if (occurrenceDate.isBefore(rule.startDate)) continue;
              if (shouldStop(occurrenceDate, startDates.length)) break;
              if (!startDates.contains(occurrenceDate)) startDates.add(occurrenceDate);
            }
          }
          currentStart = DateTime(currentStart.year + rule.interval, 1, 1);
          break;

        case RepeatType.custom:
          startDates.add(currentStart);
          currentStart = DateTime(currentStart.year + rule.interval, currentStart.month, currentStart.day);
          break;
      }
    }

    startDates.sort((a, b) => a.compareTo(b));
    return startDates;
  }
}