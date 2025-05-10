import 'package:flutter/material.dart';

/// Domain entity representing a task.
class Task {
  final String id;
  final String title;
  final String description;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final bool isRecurring;
  final String recurrenceType;
  final int recurrenceInterval;
  final List<int> recurrenceDays;
  final String duration;
  final String priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.isAllDay,
    required this.isRecurring,
    required this.recurrenceType,
    required this.recurrenceInterval,
    required this.recurrenceDays,
    required this.duration,
    required this.priority,
  });
}
