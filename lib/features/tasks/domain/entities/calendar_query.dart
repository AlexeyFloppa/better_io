class CalendarQuery {
  final DateTime startDate;
  final DateTime? endDate;
  final int? amount;
  final String? lastTaskId;

  CalendarQuery({
    required this.startDate,
    this.endDate,
    this.amount,
    this.lastTaskId,
  });
}
