// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordModelAdapter extends TypeAdapter<RecordModel> {
  @override
  final int typeId = 2;

  @override
  RecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordModel(
      id: fields[0] as int,
      doneTimestamp: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecordModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.doneTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
