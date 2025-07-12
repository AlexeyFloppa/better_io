// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      title: fields[0] as String,
      description: fields[1] as String,
      color: fields[2] as Color,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      isDateTied: fields[5] as bool,
      recurrenceRule: fields[6] as String?,
      recurrenceExceptionDates: (fields[7] as List?)?.cast<DateTime>(),
      duration: fields[8] as String,
      priority: fields[9] as String,
      category: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.isDateTied)
      ..writeByte(6)
      ..write(obj.recurrenceRule)
      ..writeByte(7)
      ..write(obj.recurrenceExceptionDates)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
