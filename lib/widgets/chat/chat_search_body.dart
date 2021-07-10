import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/providers/data.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatSearchBody extends StatefulWidget {
  final List<ChatRoom> chatRooms;

  ChatSearchBody({
    required this.chatRooms,
  });

  @override
  _ChatSearchBodyState createState() => _ChatSearchBodyState();
}

class _ChatSearchBodyState extends State<ChatSearchBody> {
  // bool isSearch = false; 서비스 커지면 검색기능 추가하기
  bool isEmptySeat = false;
  bool isNotLocked = false;
  bool isCountCriteria = false;
  String text = '';
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                      bottom: 16.0,
                    ),
                  ),
                  // Text(
                  //   '직접검색',
                  // ),
                  // Checkbox(
                  //     value: isSearch,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         isSearch = value!;
                  //       });
                  //     }),
                  Text(
                    '빈자리',
                  ),
                  Checkbox(
                      value: isEmptySeat,
                      onChanged: (value) {
                        setState(() {
                          isEmptySeat = value!;
                        });
                      }),
                  Text(
                    '공개',
                  ),
                  Checkbox(
                      value: isCountCriteria,
                      onChanged: (value) {
                        setState(() {
                          isCountCriteria = value!;
                        });
                      }),
                ],
              ),
              // if (isSearch)
              //   Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           keyboardType: TextInputType.text,
              //           onChanged: (text) {},
              //           decoration: InputDecoration(
              //               border: InputBorder.none,
              //               icon: Padding(
              //                   padding: EdgeInsets.only(left: 13),
              //                   child: Icon(
              //                     Icons.search,
              //                   ))),
              //         ),
              //       ),
              //       TextButton(
              //         onPressed: () {
              //           setState(() {
              //             text = '';
              //           });
              //         },
              //         child: Text('검색'),
              //       ),
              //     ],
              //   ),
              buildChats(),
            ],
          ),
        ),
      );

  Widget buildChats() => Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            late Widget circleAvatarChild;
            final chatRoom = widget.chatRooms[index];
            String userId = User().userId;

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
                          Icon(Icons.lock),
                          Text(
                            chatRoom.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.teal),
                          ),
                          Text(
                            '(12/30명)',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '금일 실천 : ',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                          Text(
                            '12번',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '총 실천 : ',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                          Text(
                            '212번',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '최근 실천 : ',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                          Text(
                            '3시간 전',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            ' 시작일 : ',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                          Text(
                            '2019. 11. 22.',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        '기상미션을 위한 방입니다\n다들 화이팅해봐요오루팅해봐요오팅해봐요오팅해봐요오',
                        maxLines: 2,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: widget.chatRooms.length,
        ),
      );
}
