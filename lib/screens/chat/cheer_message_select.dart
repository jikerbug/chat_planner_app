import 'package:chat_planner_app/widgets/circle_border_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheerMessageSelect extends StatefulWidget {
  @override
  _CheerMessageSelectState createState() => _CheerMessageSelectState();
}

class _CheerMessageSelectState extends State<CheerMessageSelect> {
  static String planTypeWhole = '전체';
  static String chatTypeMyself = '나';
  static String typeNone = '없음';

  final List planCategoryList = ['응원해요', '칭찬해요', '최고에요', '좋아요'];

  bool isChatCategoryFolded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 3 / 5,
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
                    Navigator.pop(context);
                  },
                  title: Text(
                    planCategoryList[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
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
