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
  final DateTime lastSentTime;

  @HiveField(5)
  final String lastMessage;

  @HiveField(6)
  final int readMessageCount;

  @HiveField(7)
  final int totalMessageCount;

  @HiveField(8)
  final int todayDoneCount;

  @HiveField(9)
  final DateTime today;

  @HiveField(10)
  final String createUser;

  ChatRoomModel({
    required this.id,
    required this.chatRoomId,
    required this.title,
    required this.category,
    required this.lastSentTime,
    required this.lastMessage,
    required this.readMessageCount,
    required this.totalMessageCount,
    required this.todayDoneCount,
    required this.today,
    required this.createUser,
  });
}
