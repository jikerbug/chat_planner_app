class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class ChatRoom {
  final String serverId;
  final String name;

  final DateTime lastMessageTime;

  const ChatRoom({
    required this.serverId,
    required this.name,
    required this.lastMessageTime,
  });
}
