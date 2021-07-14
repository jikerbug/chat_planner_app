import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  ChatRoomTile(this.chatRoom);
  ChatRoom chatRoom;
  @override
  Widget build(BuildContext context) => Container(
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
                Row(
                  children: [
                    if (chatRoom.password != '') Icon(Icons.lock),
                    Text(
                      chatRoom.chatRoomTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.teal),
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
      );
}
