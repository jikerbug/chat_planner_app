import 'package:chat_planner_app/modules/chat_list.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/chat/chat_add_screen.dart';
import 'package:chat_planner_app/screens/chat/chat_search_screen.dart';
import 'package:chat_planner_app/screens/plan/plan_add_screen.dart';
import 'package:chat_planner_app/screens/plan/plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanChatRoomSelect extends StatefulWidget {
  PlanChatRoomSelect(
      {required this.chatRoomSelectCallback, required this.callerScreen});
  final String Function(String, String) chatRoomSelectCallback;
  final String callerScreen;

  @override
  _PlanChatRoomSelectState createState() => _PlanChatRoomSelectState();
}

class _PlanChatRoomSelectState extends State<PlanChatRoomSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                categoryHeaderTile(
                  title: '공유 채팅방',
                  color: Colors.green,
                  onPressed: (type) {
                    if (type == 'search') {
                      if (widget.callerScreen == PlanScreen.id) {
                        BuildContext mainRouteContext =
                            Provider.of<Data>(context, listen: false)
                                .mainRouteContext;
                        Navigator.push(
                          mainRouteContext,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                ChatSearchScreen(),
                          ),
                        );
                      } else if (widget.callerScreen == PlanAddScreen.id) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                ChatSearchScreen(),
                          ),
                        );
                      }
                    } else if (type == 'add') {
                      if (widget.callerScreen == PlanScreen.id) {
                        BuildContext mainRouteContext =
                            Provider.of<Data>(context, listen: false)
                                .mainRouteContext;
                        Navigator.push(
                          mainRouteContext,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => ChatAddScreen(),
                          ),
                        );
                      } else if (widget.callerScreen == PlanAddScreen.id) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => ChatAddScreen(),
                          ),
                        );
                      }
                    }
                  },
                ),
                ChatList(
                  chatRoomSelectCallback: widget.chatRoomSelectCallback,
                  type: 'plan',
                  category: '전체',
                ),
                Divider(height: 0.0),
                InkWell(
                  onTap: () {
                    widget.chatRoomSelectCallback('no_chat_room_id', '없음');
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '없음',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 0.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryHeaderTile({title, color, onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(
            width: 20.0,
          ),
          MaterialButton(
            color: color,
            minWidth: 60.0,
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              onPressed('search');
            },
          ),
          SizedBox(
            width: 20.0,
          ),
          MaterialButton(
            color: color,
            minWidth: 60.0,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              onPressed('add');
            },
          ),
        ],
      ),
    );
  }
}
