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
  final List<String> texts = ['전체', '공부', '운동', '독서', '취미', '건강', '커스텀'];

  String category = '전체';

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
        Container(
          height: MediaQuery.of(context).size.width / 9,
          child: Text(
            '이번달 목표 : 책 5권읽기',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        // ChatCategoryHeader(
        //   texts: texts,
        //   selectCategoryCallback: (category) {
        //     setState(() {
        //       this.category = category;
        //     });
        //   },
        //   category: category,
        // ),
        Expanded(
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: ChatList(
              chatRoomSelectCallback: (no, meaning) {},
              category: category,
            ),
          ),
        ),
      ],
    ));
  }
}
