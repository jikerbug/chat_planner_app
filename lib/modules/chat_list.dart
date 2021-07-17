import 'package:badges/badges.dart';
import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/chat_room_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatList extends StatefulWidget {
  //type is chat or plan
  ChatList(
      {required this.chatRoomSelectCallback,
      this.type = 'chat',
      required this.category});
  final Function(String, String) chatRoomSelectCallback;
  final String type;
  final String category;
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<ChatRoomModel>('chatRoom').listenable(),
        builder: (context, Box<ChatRoomModel> box, child) {
          if (box.length == 0) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/heart_flower_2.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.fill,
                  color: Colors.black,
                ),
                Text('실천채팅방에서 계획을 함께 공유해보세요!'),
              ],
            ));
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print('builder : box.keys : ${box.keys}');
              final item = box.getAt(index);

              if (widget.category == '전체') {
                return getChatRoomTile(box, index, item!);
              }

              if (item!.category == widget.category) {
                return getChatRoomTile(box, index, item);
              } else {
                return Container();
              }
            },
            itemCount: box.length,
          );
        });
  }

  Widget getChatRoomTile(box, index, ChatRoomModel item) {
    return InkWell(
      onTap: () {
        if (widget.type == 'chat') {
          //TODO:이 부분 다시 변경해놓기
          //HiveChatApi.setChatRoomAtLatestListOrder(item.chatRoomId);
          ChatRoomEnterFunctions.chatRoomEnterProcess(
              context, item.chatRoomId, item.title);
        } else if (widget.type == 'plan') {
          widget.chatRoomSelectCallback(item.chatRoomId, item.title);
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
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
                '${item.todayDoneCount}회',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              radius: 25,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          item.currentMemberNum.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    DateTimeFunction.lastSentTimeFormatter(item.lastSentTime),
                    style: TextStyle(fontSize: 13.0),
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
                    item.lastMessage,
                    style: TextStyle(fontSize: 13.0),
                  ),
                  Badge(
                    showBadge: (item.totalMessageCount == item.readMessageCount)
                        ? false
                        : true,
                    toAnimate: false,
                    position: BadgePosition.topStart(),
                    badgeContent: Text(
                      '${item.totalMessageCount - item.readMessageCount}',
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
      ),
    );
  }
}
