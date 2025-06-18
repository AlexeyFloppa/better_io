// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTaskModelAdapter extends TypeAdapter<HiveTaskModel> {
  @override
  final int typeId = 0;

  @override
  HiveTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTaskModel(
      title: fields[0] as String,
      description: fields[1] as String,
      color: fields[2] as Color,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      isAllDay: fields[5] as bool,
      recurrenceRule: fields[6] as String?,
      duration: fields[7] as String,
      priority: fields[8] as String,
      category: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTaskModel obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.isAllDay)
      ..writeByte(6)
      ..write(obj.recurrenceRule)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
