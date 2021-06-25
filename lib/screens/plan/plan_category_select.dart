import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/widgets/circle_border_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanCategorySelect extends StatefulWidget {
  PlanCategorySelect({required this.chatRoomCallback, required this.userId});
  final String Function(String, String) chatRoomCallback;
  final String userId;

  @override
  _PlanCategorySelectState createState() => _PlanCategorySelectState();
}

class _PlanCategorySelectState extends State<PlanCategorySelect> {
  static String planTypeWhole = '전체';
  static String chatTypeMyself = '나';
  static String typeNone = '없음';

  final List planCategoryList = [planTypeWhole, typeNone, '운동'];
  final List chatCategoryList = [chatTypeMyself, typeNone, '친구방'];

  bool isChatCategoryFolded = false;

  @override
  Widget build(BuildContext context) {
    final List chatRoomIdList = [widget.userId, 'none', 'test_friend'];
    return Container(
      height: MediaQuery.of(context).size.height * 3 / 5,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Column(
              children: [
                categoryHeaderTile(
                    title: '계획 카테고리',
                    color: Colors.teal,
                    onPressed: () {},
                    isAddButtonExist: true),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return categoryTile(
                          title: planCategoryList[index],
                          planCount: 1,
                          index: index);
                    },
                    itemCount: planCategoryList.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.0,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 0.0,
          ),
          Flexible(
            child: Column(
              children: [
                categoryHeaderTile(
                    title: '공유되는 채팅방',
                    color: Colors.green,
                    onPressed: () {},
                    isAddButtonExist: false),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.chatRoomCallback(
                              chatRoomIdList[index], chatCategoryList[index]);
                          Navigator.pop(context);
                        },
                        child: categoryTile(
                            title: chatCategoryList[index],
                            planCount: 1,
                            index: index),
                      );
                    },
                    itemCount: chatCategoryList.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.0,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryTile({title, planCount, index}) {
    bool isFixed = false;

    if ((title == planTypeWhole || title == chatTypeMyself && index == 0) ||
        (title == typeNone && index == 1)) {
      isFixed = true;
    }
    return ListTile(
      leading: CircleBorderBox(
        radius: 15.0,
        title: planCount.toString(),
        textColor: Colors.black,
        backGroundColor: Colors.transparent,
        borderColor: Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: isFixed ? null : Icon(Icons.clear),
    );
  }

  Widget categoryHeaderTile({title, color, isAddButtonExist, onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: (isAddButtonExist)
                    ? MaterialStateProperty.all<Color>(color)
                    : MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: (isAddButtonExist)
                    ? MaterialStateProperty.all<double>(3.0)
                    : MaterialStateProperty.all<double>(0.0),
              ),
              child: Icon(
                Icons.add,
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
