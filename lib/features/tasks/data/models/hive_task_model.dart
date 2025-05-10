import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_task_model.g.dart';

/// Hive model for storing task data.
@HiveType(typeId: 0)
class HiveTaskModel extends HiveObject {
  @HiveField(0)
  final int taskId;

  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;

  @HiveField(3)
  final Color color;

  @HiveField(4)
  final DateTime startDate;
  @HiveField(5)
  final DateTime endDate;
  @HiveField(6)
  final bool isAllDay;

  @HiveField(7)
  final bool isRecurring;
  @HiveField(8)
  final String recurrenceType;
  @HiveField(9)
  final int recurrenceInterval;
  @HiveField(10)
  final List<int> recurrenceDays;

  @HiveField(11)
  final String duration;
  @HiveField(12)
  final String priority;

  HiveTaskModel({
    required this.taskId,
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

  HiveTaskModel copyWithNewDate(DateTime newStart, Duration duration) {
  return HiveTaskModel(
    taskId: taskId,
    title: title,
    description: description,
    startDate: newStart,
    endDate: newStart.add(duration),
    isAllDay: isAllDay,
    isRecurring: isRecurring,
    recurrenceType: recurrenceType,
    recurrenceInterval: recurrenceInterval,
    recurrenceDays: recurrenceDays,
    color: color,
    duration: duration.inDays.toString(), // Or keep the original string if needed
    priority: priority,
  );
}

}
