// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatRoomModelAdapter extends TypeAdapter<ChatRoomModel> {
  @override
  final int typeId = 5;

  @override
  ChatRoomModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRoomModel(
      id: fields[0] as int,
      chatRoomId: fields[1] as String,
      title: fields[2] as String,
      category: fields[3] as String,
      lastSentTime: fields[4] as DateTime,
      lastMessage: fields[5] as String,
      readMessageCount: fields[6] as int,
      totalMessageCount: fields[7] as int,
      todayDoneCount: fields[8] as int,
      today: fields[9] as DateTime,
      createUser: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chatRoomId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.lastSentTime)
      ..writeByte(5)
      ..write(obj.lastMessage)
      ..writeByte(6)
      ..write(obj.readMessageCount)
      ..writeByte(7)
      ..write(obj.totalMessageCount)
      ..writeByte(8)
      ..write(obj.todayDoneCount)
      ..writeByte(9)
      ..write(obj.today)
      ..writeByte(10)
      ..write(obj.createUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
