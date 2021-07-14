import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/modules/chat_list.dart';
import 'package:chat_planner_app/widgets/chat/chat_category_header.dart';
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
  final List<String> texts = ['전체', '공부', '운동', '독서', '생활습관', '커스텀'];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.fabCallback(ChatListScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        InfoPanel('reward'),
        ChatCategoryHeader(
          texts: texts,
          selectCategoryCallback: () {},
        ),
        Expanded(
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: ChatList(
              chatRoomSelectCallback: (no, meaning) {},
            ),
          ),
        ),
      ],
    ));
  }
}
