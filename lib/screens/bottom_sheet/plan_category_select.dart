import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanCategorySelect extends StatefulWidget {
  @override
  _PlanCategorySelectState createState() => _PlanCategorySelectState();
}

class _PlanCategorySelectState extends State<PlanCategorySelect> {
  final List planCategoryList = ['전체', '운동', '테스', '코딩', '스트레칭'];

  final List chatCategoryList = ['친구방', '가족방', '코딩방'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 5 / 6,
      child: Column(
        children: [
          Material(
            elevation: 5.0,
            child: ListTile(
              leading: Text(
                '계획 카테고리',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.teal),
              ),
              title: Container(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 4 / 7,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.teal)),
                  child: Icon(
                    Icons.add,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    planCategoryList[index],
                  ),
                );
              },
              itemCount: planCategoryList.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          Material(
            elevation: 5.0,
            child: ListTile(
                title: Text(
              '채팅방으로 분류',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.green),
            )),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    chatCategoryList[index],
                  ),
                );
              },
              itemCount: chatCategoryList.length,
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
