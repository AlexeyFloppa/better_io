import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'hive_task_model.g.dart';

@HiveType(typeId: 0)
class HiveTaskModel extends HiveObject {
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
  final bool isAllDay;

  @HiveField(6)
  final String? recurrenceRule;

  @HiveField(7)
  final String duration;

  @HiveField(8)
  final String priority;

  HiveTaskModel({
    required this.title,
    required this.description,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.isAllDay,
    this.recurrenceRule,
    required this.duration,
    required this.priority,
  });
}
