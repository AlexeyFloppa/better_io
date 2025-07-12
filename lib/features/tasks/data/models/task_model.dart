import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part '../generated/task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final Color color;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final bool isDateTied;

  @HiveField(6)
  final String? recurrenceRule;

  @HiveField(7)
  final List<DateTime>? recurrenceExceptionDates;

  @HiveField(8)
  final String duration;

  @HiveField(9)
  final String priority;

  @HiveField(10)
  final String category;

  TaskModel({
    required this.title,
    required this.description,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.isDateTied,
    this.recurrenceRule,
    this.recurrenceExceptionDates,
    required this.duration,
    required this.priority,
    required this.category,
  });
}
