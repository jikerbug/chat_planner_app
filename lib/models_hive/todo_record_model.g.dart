// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoRecordModelAdapter extends TypeAdapter<TodoRecordModel> {
  @override
  final int typeId = 4;

  @override
  TodoRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoRecordModel(
      id: fields[0] as int,
      doneTimestamp: fields[1] as String,
      planCreatedTime: fields[2] as String,
      title: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TodoRecordModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.doneTimestamp)
      ..writeByte(2)
      ..write(obj.planCreatedTime)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
