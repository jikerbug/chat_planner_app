import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/widgets/chat/chat_category_header.dart';
import 'package:chat_planner_app/widgets/chat/chat_room_tile.dart';
import 'package:chat_planner_app/widgets/chat/chat_search_body.dart';
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
  //final List<String> texts = ['전체', '공부', '운동', '독서', '취미', '건강', '커스텀'];
  final List<String> texts = [
    '전체',
    '\u{1F4D2}',
    '\u{1F3C3}',
    '\u{1F4D6}',
    '\u{1F3B5}',
    '건강',
    '커스텀'
  ];
  bool isDoneSort = true;
  bool isCreatedTimeSort = false;
  String selectedCategory = '전체';
  String selectedRankCriteria = '';

  late TabController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    _controller.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    if (_controller.indexIsChanging) {
      setState(() {
        _currentIndex = _controller.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget categoryHeader = ChatCategoryHeader(
      texts: texts,
      selectCategoryCallback: (selectedCategory) {
        setState(() {
          this.selectedCategory = selectedCategory;
        });
      },
      category: selectedCategory,
    );
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
                  categoryHeader,
                  ChatSearchBody(
                      selectedCategory: selectedCategory,
                      criteria: 'createdTime')
                ],
              ),
              Column(
                children: [
                  categoryHeader,
                  ChatSearchBody(
                      selectedCategory: selectedCategory,
                      criteria: 'weeklyDoneCount')
                ],
              ),
              Column(
                children: [
                  categoryHeader,
                  ChatSearchBody(
                      selectedCategory: selectedCategory,
                      criteria: 'totalDoneCount')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildLoading() => Expanded(
      child: Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
