import 'package:chat_planner_app/api/firestore_cheer_api.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/widgets/circle_border_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheerMessageSelect extends StatefulWidget {
  CheerMessageSelect({this.cheerUserId, this.plan, this.planType});
  final cheerUserId;
  final plan;
  final planType;
  @override
  _CheerMessageSelectState createState() => _CheerMessageSelectState();
}

class _CheerMessageSelectState extends State<CheerMessageSelect> {
  static String planTypeWhole = '전체';
  static String chatTypeMyself = '나';
  static String typeNone = '없음';

  final List cheerCategoryList = ['응원해요', '칭찬해요', '좋아요'];

  bool isChatCategoryFolded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          categoryHeaderTile(
              title: '전송할 메시지',
              color: Colors.teal,
              onPressed: () {},
              isAddButtonExist: false),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    String type;
                    if (cheerCategoryList[index] == '응원해요') {
                      type = '응원';
                    } else if (cheerCategoryList[index] == '칭찬해요') {
                      type = '칭찬';
                    } else if (cheerCategoryList[index] == '좋아요') {
                      type = '좋아';
                    } else {
                      type = 'no_way';
                    }

                    FireStoreCheerApi.sendCheerMessage(
                        cheerUserId: widget.cheerUserId,
                        senderNickname: User().nickname,
                        senderUserId: User().userId,
                        type: type,
                        plan: widget.plan,
                        planType: widget.planType);
                    Navigator.pop(context);
                  },
                  title: Text(
                    cheerCategoryList[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
              itemCount: cheerCategoryList.length,
              separatorBuilder: (context, index) {
                return Divider(
                  height: 0.0,
                );
              },
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
