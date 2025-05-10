// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<HiveTaskModel> {
  @override
  final int typeId = 0;

  @override
  HiveTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTaskModel(
      taskId: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      color: fields[3] as Color,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      isAllDay: fields[6] as bool,
      isRecurring: fields[7] as bool,
      recurrenceType: fields[8] as String,
      recurrenceInterval: fields[9] as int,
      recurrenceDays: (fields[10] as List).cast<int>(),
      duration: fields[11] as String,
      priority: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTaskModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.isAllDay)
      ..writeByte(7)
      ..write(obj.isRecurring)
      ..writeByte(8)
      ..write(obj.recurrenceType)
      ..writeByte(9)
      ..write(obj.recurrenceInterval)
      ..writeByte(10)
      ..write(obj.recurrenceDays)
      ..writeByte(11)
      ..write(obj.duration)
      ..writeByte(12)
      ..write(obj.priority);
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
