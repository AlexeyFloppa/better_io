import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final String? recurrenceRule;
  final List<DateTime>? recurrenceExceptionDates; // Optional recurrence exceptions
  final String duration;
  final String priority;
  final String category; // Optional category field

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.isAllDay,
    required this.recurrenceRule,
    this.recurrenceExceptionDates,
    required this.duration,
    required this.priority,
    required this.category,
  });
  Task copyWith({
    String? title,
    String? description,
    Color? color,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    String? recurrenceRule,
    List<DateTime>? recurrenceExceptionDates,
    String? duration,
    String? priority,
    String? category,  // Category can be changed in copy
  }) {
    return Task(
      id: id, // ✅ preserve original ID
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurrenceExceptionDates: recurrenceExceptionDates ?? this.recurrenceExceptionDates,
      duration: duration ?? this.duration,
      priority: priority ?? this.priority,
      category: category ?? this.category, // Category is not changed in copy
    );
  }
}
