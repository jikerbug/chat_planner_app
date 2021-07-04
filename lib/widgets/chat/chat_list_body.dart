import 'package:badges/badges.dart';
import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/providers/data.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListBody extends StatelessWidget {
  final List<ChatRoom> chatRooms;

  ChatListBody({
    required this.chatRooms,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            height: 70,
            child: ListTile(
              onTap: () {
                ChatRoomEnterFunctions.chatRoomEnterProcess(
                    context, chatRoom.serverId, chatRoom.name);
              },
              leading: Badge(
                animationType: BadgeAnimationType.scale,
                position: BadgePosition.bottomEnd(),
                badgeColor: Colors.teal,
                badgeContent: Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                ),
                child: Badge(
                  animationType: BadgeAnimationType.scale,
                  badgeContent: Text(
                    '3',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: Colors.teal,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        '0회',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      radius: 25,
                    ),
                  ),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chatRoom.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '스플릿스트레칭 실천 / 오전 12:21      ',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: chatRooms.length,
      );
}
