import 'package:chat_planner_app/models/chat_room_model.dart';
import 'package:chat_planner_app/widgets/chat/chat_list_body.dart';
import 'package:chat_planner_app/widgets/chat/chat_list_header.dart';
import 'package:chat_planner_app/widgets/plan/info_panel.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  static const String id = 'rank_screen';

  ChatListScreen({required this.fabFunc});
  final Function fabFunc;

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatRoom> chatRooms = [
    ChatRoom(
      serverId: 'mindnetworkcorp@gmail',
      lastMessageTime: DateTime.now(),
      name: "나와의 채팅",
    ),
    ChatRoom(
      serverId: 'soso',
      lastMessageTime: DateTime.now(),
      name: "가족톡",
    ),
    ChatRoom(
      serverId: 'soso',
      lastMessageTime: DateTime.now(),
      name: "코딩톡",
    ),
  ];

  final List<String> texts = ['전체', '공부', '운동', '도전', '독서', '창작', '연습', '코딩'];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.fabFunc(ChatListScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        InfoPanel('reward'),
        FriendsHeader(texts: texts),
        FriendsBody(chatRooms: chatRooms),
      ],
    ));
  }
}
