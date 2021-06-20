import 'package:flutter/material.dart';
import 'package:chat_planner_app/screens/profile_view_screen.dart';

class AppBarTitle extends StatelessWidget {
  AppBarTitle(
      {required this.chatRoomId,
      required this.friendUserId,
      required this.extendCount,
      required this.friendProfileUrl,
      required this.friendNickname});
  final String chatRoomId;
  final String friendUserId;
  final String friendProfileUrl;
  final String friendNickname;
  final int extendCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: (extendCount >= 2)
          ? [
              Text(
                friendNickname,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                  child: (friendProfileUrl != "no_profile_image")
                      ? CircleAvatar(
                          radius: 23.0,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(friendProfileUrl))
                      : CircleAvatar(
                          radius: 23.0,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                  onTap: () {
                    Navigator.pushNamed(context, ProfileViewScreen.id,
                        arguments: {'profileUrl': friendProfileUrl});
                  }),
            ]
          : [
              Text(
                friendNickname,
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                child: Image.asset(
                  'images/question.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.scaleDown,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
            ],
    );
  }
}
