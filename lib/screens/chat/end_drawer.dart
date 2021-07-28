import 'package:chat_planner_app/api_in_local/hive_chat_api.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:flutter/material.dart';

class EndDrawer extends StatelessWidget {
  EndDrawer({required this.chatRoomId, required this.memberList});

  final String chatRoomId;
  final List<dynamic> memberList;
  @override
  Widget build(BuildContext context) {
    memberList.addAll(['a', '그로잉', '볶음밥']);
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.group),
              title: Text('실천친구 목록'),
            ),
            Expanded(
                flex: 10,
                child: ListView.builder(
                    itemCount: memberList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(memberList[index]),
                      );
                    })),
            Expanded(
              flex: 1,
              child: ListTile(
                tileColor: Colors.grey[300],
                leading: Icon(Icons.exit_to_app),
                title: Text('채팅방 나가기'),
                onTap: () {
                  print("채팅방 나가기?");
                  CustomDialogFunction.dialog(
                      isLeftAlign: false,
                      context: context,
                      isTwoButton: true,
                      onPressed: () {
                        HiveChatApi.exitChatRoom(chatRoomId);
                        Navigator.pop(context);
                      },
                      title: "채팅방 나가기",
                      text: '채팅방을 나가시겠습니까?',
                      size: 'small');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
