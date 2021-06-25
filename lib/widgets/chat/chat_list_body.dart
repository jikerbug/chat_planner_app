import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/providers/data.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomsBody extends StatelessWidget {
  final List<ChatRoom> chatRooms;

  ChatRoomsBody({
    required this.chatRooms,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          late Widget circleAvatarChild;
          final chatRoom = chatRooms[index];
          String userId = Provider.of<Data>(context).userId;

          if (chatRoom.serverId == userId) {
            circleAvatarChild = Icon(
              Icons.person,
              color: Colors.black,
            );
          } else {
            circleAvatarChild = Icon(
              Icons.people_rounded,
              color: Colors.black,
            );
          }

          return Container(
            height: 70,
            child: ListTile(
              onTap: () {
                ChatRoomEnterFunctions.chatRoomEnterProcess(
                    context, chatRoom.serverId, chatRoom.name);
              },
              leading: Material(
                shape: CircleBorder(),
                elevation: 3.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: circleAvatarChild,
                  radius: 25,
                ),
              ),
              title: Text(
                chatRoom.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        itemCount: chatRooms.length,
      );
}
