import 'dart:io';

import 'package:chat_planner_app/api/firebase_chat_api.dart';
import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/widgets/chat/chat_category_header.dart';
import 'package:chat_planner_app/widgets/chat/chat_room_tile.dart';
import 'package:chat_planner_app/widgets/chat/chat_search_body.dart';
import 'package:chat_planner_app/widgets/chat/search_panel.dart';
import 'package:chat_planner_app/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'chat_add_screen.dart';

class ChatSearchScreen extends StatefulWidget {
  static const String id = 'chat_search_screen';

  @override
  _ChatSearchScreenState createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen>
    with TickerProviderStateMixin {
  final List<String> texts = ['공부', '운동', '독서', '취미', '생활습관', '커스텀'];
  bool isDoneSort = true;
  bool isCreatedTimeSort = false;
  String selectedCategory = '공부';
  String selectedRankCriteria = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.4, 0.5],
          colors: [
            Colors.green[300]!,
            Colors.green[700]!,
            Colors.green[800]!,
          ],
        ),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: TabBar(
              labelPadding: EdgeInsets.all(0),
              tabs: [
                Tab(
                    icon: Text(
                  '개설일',
                  style: TextStyle(fontSize: 13.0),
                )),
                Tab(
                  icon: Text(
                    '주간실천',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
                Tab(
                  icon: Text(
                    '총실천',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true, //full screen으로 modal 쓸 수 있게 해준다.
                context: context,
                builder: (context) => ChatAddScreen(),
              );
            },
            backgroundColor: Colors.teal,
            child: Icon(
              Icons.add,
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  ChatCategoryHeader(
                    texts: texts,
                    selectCategoryCallback: (selectedCategory) {
                      setState(() {
                        this.selectedCategory = selectedCategory;
                      });
                    },
                  ),
                  getChatRoomList(selectedCategory, 'createdTime')
                ],
              ),
              Column(
                children: [
                  ChatCategoryHeader(
                      texts: texts, selectCategoryCallback: () {}),
                ],
              ),
              Column(
                children: [
                  ChatCategoryHeader(
                      texts: texts, selectCategoryCallback: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getChatRoomList(selectedCategory, criteria) => PaginateFirestore(
      key: Key(selectedCategory),
      physics: BouncingScrollPhysics(),
      itemsPerPage: 7,
      shrinkWrap: true,
      reverse: true,
      //item builder type is compulsory.
      itemBuilderType: PaginateBuilderType.listView, //Change types accordingly
      itemBuilder: (index, context, documentSnapshot) {
        Map chatInfo = documentSnapshot.data() as Map;

        return Text(chatInfo['chatRoomTitle']);
        return ChatRoomTile(ChatRoom(
          chatRoomId: chatInfo['chatRoomId'],
          chatRoomTitle: chatInfo['chatRoomTitle'],
          weeklyDoneCount: chatInfo['weeklyDoneCount'],
          totalDoneCount: chatInfo['totalDoneCount'],
          createdTime: chatInfo['createdTime'],
          createUser: chatInfo['createUser'],
          description: chatInfo['description'],
          currentMemberNum: chatInfo['memberList'].length,
          maxMemberNum: chatInfo['maxMemberNum'],
          password: chatInfo['password'],
        ));
      },
// orderBy is compulsory to enable pagination
      query: FireStoreApi.getChatRoomsQuery(selectedCategory, criteria),
// to fetch real-time data
      isLive: true,
    );
Widget buildLoading() => Expanded(
      child: Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
