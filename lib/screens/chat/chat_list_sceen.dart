import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/widgets/chat/chat_list_body.dart';
import 'package:chat_planner_app/widgets/chat/chat_list_header.dart';
import 'package:chat_planner_app/widgets/plan/info_panel.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  static const String id = 'rank_screen';

  ChatListScreen({required this.fabCallback});
  final Function fabCallback;

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<String> texts = ['전체', '공부', '운동', '도전', '독서', '창작', '연습', '코딩'];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.fabCallback(ChatListScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatRoom> chatRooms = [
      ChatRoom(
        serverId: User().userId,
        lastMessageTime: DateTime.now(),
        name: "나와의 채팅",
      ),
      ChatRoom(
        serverId: 'test_friend',
        lastMessageTime: DateTime.now(),
        name: "친구방",
      ),
    ];

    return SafeArea(
        child: Column(
      children: [
        InfoPanel('reward'),
        FriendsHeader(texts: texts),
        ChatRoomsBody(chatRooms: chatRooms),
      ],
    ));
  }
}
