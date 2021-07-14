class ChatRoom {
  final String chatRoomId;
  final String chatRoomTitle;
  final int weeklyDoneCount;
  final int totalDoneCount;
  final String createdTime;
  final String createUser;
  final String description;
  final int currentMemberNum;
  final int maxMemberNum;
  final String password;

  const ChatRoom({
    required this.chatRoomId,
    required this.chatRoomTitle,
    required this.weeklyDoneCount,
    required this.totalDoneCount,
    required this.createdTime,
    required this.createUser,
    required this.description,
    required this.currentMemberNum,
    required this.maxMemberNum,
    required this.password
  });
}
