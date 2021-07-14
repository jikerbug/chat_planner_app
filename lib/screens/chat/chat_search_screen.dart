import 'dart:io';

import 'package:chat_planner_app/api/firebase_chat_api.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/widgets/chat/chat_category_header.dart';
import 'package:chat_planner_app/widgets/chat/chat_search_body.dart';
import 'package:chat_planner_app/widgets/chat/search_panel.dart';
import 'package:chat_planner_app/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
                  getDifferentCriteriaList(selectedCategory, 'createdTime'),
                ],
              ),
              Column(
                children: [
                  ChatCategoryHeader(
                      texts: texts, selectCategoryCallback: () {}),
                  getDifferentCriteriaList(selectedCategory, 'weeklyDoneCount'),
                ],
              ),
              Column(
                children: [
                  ChatCategoryHeader(
                      texts: texts, selectCategoryCallback: () {}),
                  getDifferentCriteriaList(selectedCategory, 'totalDoneCount'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> test() async {
    await Future.delayed(Duration(seconds: 3));
    return 'good';
  }
}

Widget getDifferentCriteriaList(selectedCategory, criteria) => FutureBuilder(
    future: FirebaseChatApi.getChatInfoList(selectedCategory, criteria),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List chatInfoList = snapshot.data as List;
        final List<ChatRoom> chatRooms = [];
        for (Map chatInfo in chatInfoList) {
          chatRooms.add(ChatRoom(
            chatRoomId: chatInfo['chatRoomId'],
            chatRoomTitle: chatInfo['chatRoomTitle'],
            weeklyDoneCount: chatInfo['weeklyDoneCount'],
            totalDoneCount: chatInfo['totalDoneCount'],
            createdTime: chatInfo['createdTime'],
            createUser: chatInfo['createUser'],
            description: chatInfo['description'],
            currentMemberNum: 1,
            maxMemberNum: 15,
            password: chatInfo['password'],
          ));
        }
        return ChatSearchBody(chatRooms: chatRooms);
      } else {
        return buildLoading();
      }
    });
Widget buildLoading() => Expanded(
      child: Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
