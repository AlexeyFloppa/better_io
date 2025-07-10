import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Hive adapter for Flutter [Color] objects.
class HiveColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 1;

  @override
  Color read(BinaryReader reader) => Color(reader.readUint32());

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeUint32(obj.value); // ignore: deprecated_member_use
  }
}
