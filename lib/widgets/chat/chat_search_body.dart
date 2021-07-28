import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/modules/chat_search_list.dart';

import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'chat_room_tile.dart';

class ChatSearchBody extends StatefulWidget {
  final String selectedCategory;
  final String criteria;

  ChatSearchBody({
    required this.selectedCategory,
    required this.criteria,
  });

  @override
  _ChatSearchBodyState createState() => _ChatSearchBodyState();
}

class _ChatSearchBodyState extends State<ChatSearchBody> {
  // bool isSearch = false; 서비스 커지면 검색기능 추가하기 algoria
  bool isEmptySeat = false;
  bool isNotLocked = false;
  bool isCountCriteria = false;
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(
            //         top: 16.0,
            //         bottom: 16.0,
            //       ),
            //     ),
            //     Text(
            //       '빈자리',
            //     ),
            //     Checkbox(
            //         value: isEmptySeat,
            //         onChanged: (value) {
            //           setState(() {
            //             isEmptySeat = value!;
            //           });
            //         }),
            //     Text(
            //       '공개',
            //     ),
            //     Checkbox(
            //         value: isCountCriteria,
            //         onChanged: (value) {
            //           setState(() {
            //             isCountCriteria = value!;
            //           });
            //         }),
            //   ],
            // ),
            ChatSearchList(
                selectedCategory: widget.selectedCategory,
                criteria: widget.criteria),
          ],
        ),
      ),
    );
  }
}
