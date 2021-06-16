//habit의 종류
//1. 일반
//2. 기상 - not mvp
//3. 일회성 - not mvp
//4. 서브습관 - not mvp
// 학생들 대상이라면,,,, 동조효과가 좀더 가미되어야 하지 않을까?
// 즉, 습관을 큐레이션 할 수 있는것?....
// 즉, 자신의 습관을 공유하고, 이 게시습관을 통해 하트를 받을 수 있게?
// 그것 이외에도 7시기상, 6시기상 같은 것들에 대해 전체 사용자가 얼마나 해당 습관을
// 채택하고 있는지 보는 것도 좋을 것 같다.

import 'package:chat_planner_app/api/firebase_plan_api.dart';
import 'package:chat_planner_app/models/plan_model.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:chat_planner_app/api_in_local/plan_api.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class PlanAddScreen extends StatefulWidget {
  static String id = 'HabitAddScreen';
  @override
  _PlanAddScreenState createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
  String title = '';
  var textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: Column(
            children: [
              Text(
                '계획 추가',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                width: 200.0,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: textEditingController,
                  autofocus: true,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: 5,
                          top: 20), //  <- you can it to 0.0 for no space
                      isDense: true),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedButton(
                      minWidth: 100.0,
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      title: '닫기'),
                  RoundedButton(
                      minWidth: 100.0,
                      color: Colors.green,
                      onPressed: () {
                        if (title != '') {
                          final box = Hive.box<PlanModel>('word');

                          int id = 0;

                          if (box.isNotEmpty) {
                            final prevItem = box.getAt(box.length - 1);

                            if (prevItem != null) {
                              id = prevItem.id + 1;
                            }
                          }
                          print(id);

                          box.put(
                            id,
                            PlanModel(
                              id: id,
                              title: title,
                              isChecked: false,
                              timestamp: DateTime.now().toString(),
                            ),
                          );
                          // Data providerData =
                          //     Provider.of<Data>(context, listen: false);
                          // int planLength = providerData.listCount;
                          // String timestamp = DateTime.now().toString();
                          // Provider.of<Data>(this.context, listen: false)
                          //     .addToList(title, timestamp, 0, planLength);
                          //
                          // PlanApi.addPlan(title, timestamp, planLength);
                          // Navigator.pop(context);
                        }
                      },
                      title: '추가'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
