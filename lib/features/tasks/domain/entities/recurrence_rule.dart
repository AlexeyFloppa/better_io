enum RecurrenceType {
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
  custom,
}

enum RecurrenceEndType {
  forever,
  untilDate,
  count,
}

class RecurrenceRule {
  final RecurrenceType type;
  final int interval;
  final List<int>?
      recurrencePoints;
  final DateTime startDate;
  final DateTime endDate;
  final RecurrenceEndType endType;
  final DateTime? untilDate;
  final int? maxOccurrences;

  RecurrenceRule({
    required this.type,
    required this.interval,
    this.recurrencePoints,
    required this.startDate,
    required this.endDate,
    required this.endType,
    this.untilDate,
    this.maxOccurrences,
  });
}
