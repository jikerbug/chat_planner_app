import 'package:badges/badges.dart';
import 'package:chat_planner_app/api_in_local/hive_chat_api.dart';
import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/chat_room_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<ChatRoomModel>('chatRoom').listenable(),
        builder: (context, Box<ChatRoomModel> box, child) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print('builder : box.keys : ${box.keys}');
              final item = box.getAt(index);
              return getChatRoomTile(box, index, item!);
            },
            itemCount: box.length,
          );
        });
  }

  Widget getChatRoomTile(box, index, ChatRoomModel item) {
    String lastSentInfo = '${item.lastDoneMessage}';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      height: 70,
      child: ListTile(
        onTap: () {
          //TODO:이 부분 다시 변경해놓기
          //HiveChatApi.setChatRoomAtLatestListOrder(item.chatRoomId);
          ChatRoomEnterFunctions.chatRoomEnterProcess(
              context, item.chatRoomId, item.title);
        },
        leading: Container(
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
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            radius: 25,
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateTimeFunction.lastDoneTimeFormatter(item.lastDoneTime),
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            SizedBox(
              height: 3.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lastSentInfo,
                  style: TextStyle(fontSize: 13.0),
                ),
                Badge(
                  toAnimate: false,
                  position: BadgePosition.topStart(),
                  badgeContent: Text(
                    '3',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Text(
                    '    ',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
