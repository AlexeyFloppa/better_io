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
    required this.recurrenceRule,
    required this.duration,
    required this.priority,
  });
  Task copyWith({
    String? title,
    String? description,
    Color? color,
    DateTime? startDate,
    DateTime? endDate,
    bool? isAllDay,
    String? recurrenceRule,
    String? duration,
    String? priority,
  }) {
    return Task(
      id: this.id, // ✅ preserve original ID
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      duration: duration ?? this.duration,
      priority: priority ?? this.priority,
    );
  }
}
