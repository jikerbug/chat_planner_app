import 'package:chat_planner_app/api_in_local/hive_chat_api.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  ChatRoomTile(this.chatRoom);
  ChatRoom chatRoom;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          String description = chatRoom.description == ''
              ? '채팅방 설명이 없습니다.'
              : chatRoom.description;
          CustomDialogFunction.dialog(
              context: context,
              isTwoButton: true,
              isLeftAlign: true,
              onPressed: () {
                HiveChatApi.addChatRoom(
                  chatRoomId: chatRoom.chatRoomId,
                  title: chatRoom.chatRoomTitle,
                  category: chatRoom.category,
                  lastSentTime: DateTime.now(),
                  lastMessage: '채팅방 입장',
                  totalMessageCount: 0,
                  todayDoneCount: 0,
                  today: DateTime.now(),
                );
                Navigator.pop(context);
              },
              title: '실천채팅방 입장',
              text: description,
              size: 'big');
        },
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Material(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    chatRoom.category,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.teal),
                  ),
                  Row(
                    children: [
                      if (chatRoom.password != '') Icon(Icons.lock),
                      Text(
                        chatRoom.chatRoomTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Text(
                        '(${chatRoom.currentMemberNum}명/${chatRoom.maxMemberNum}명)',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '주간 실천 : ',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        chatRoom.weeklyDoneCount.toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '총 실천 : ',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        chatRoom.totalDoneCount.toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '개설자 : ',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        chatRoom.createUser,
                        style: TextStyle(fontSize: 13),
                      ),
                      Text(
                        ' 시작일 : ',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      Text(
                        DateTimeFunction.lastSentTimeFormatter(
                            DateTime.parse(chatRoom.createdTime)),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 10.0,
                    color: Colors.grey[600],
                  ),
                  if (chatRoom.password != '')
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                  if (chatRoom.password == '')
                    Text(
                      chatRoom.description,
                      maxLines: 2, //이렇게 하면 그냥 2줄에서 더 안길어지고 짤린다! 굿!
                      style: TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
