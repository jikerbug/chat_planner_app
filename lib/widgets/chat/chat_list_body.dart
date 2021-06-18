import 'package:chat_planner_app/models/chat_room_model.dart';

import 'package:flutter/material.dart';

class FriendsBody extends StatelessWidget {
  final List<User> users;

  const FriendsBody({
    required this.users,
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
          final user = users[index];

          return Container(
            height: 70,
            child: ListTile(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => ChatPage(user: user),
                // ));
              },
              leading: CircleAvatar(
                radius: 25,
              ),
              title: Text(user.name),
            ),
          );
        },
        itemCount: users.length,
      );
}
