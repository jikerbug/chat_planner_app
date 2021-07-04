import 'package:hive/hive.dart';

part 'chat_room_model.g.dart';

@HiveType(typeId: 5)
class ChatRoomModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String chatRoomId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime lastDoneTime;

  @HiveField(5)
  final String lastDoneMessage;

  // @HiveField(5)
  // final int unSeenMessageCount;
  //
  // @HiveField(6)
  // final int unSeenDoneMessageCount;

  ChatRoomModel({
    required this.id,
    required this.chatRoomId,
    required this.title,
    required this.category,
    required this.lastDoneTime,
    required this.lastDoneMessage,
  });
}
