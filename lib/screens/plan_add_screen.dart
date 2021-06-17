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

import 'package:chat_planner_app/api_in_local/hive_plan_api.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/functions/datetime_function.dart';
import 'package:chat_planner_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class PlanAddScreen extends StatefulWidget {
  static String id = 'PlanAddScreen';
  @override
  _PlanAddScreenState createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
  String title = '';
  var textEditingController = TextEditingController();
  List<Day> dayList = DateTimeFunction.dayListForPlanAddScreen;
  bool isHabit = true;
  bool isEveryDay = false;
  bool isWeekDay = false;
  String noLimitNotation = DateTimeFunction.noLimitNotation;
  late String habitEndOrTaskDateInfo = noLimitNotation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 200.0,
                  child: TextField(
                    textAlign: TextAlign.start,
                    controller: textEditingController,
                    autofocus: true,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                        hintText: '실천할 계획을 입력해주세요',
                        contentPadding: EdgeInsets.only(
                            bottom: 5,
                            top: 20), //  <- you can it to 0.0 for no space
                        isDense: true),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: isHabit,
                        onChanged: (value) {
                          if (value == true) {
                            setState(() {
                              isHabit = true;
                            });
                          }
                        }),
                    Text('습관'),
                    Checkbox(
                        value: !isHabit,
                        onChanged: (value) {
                          if (value == true) {
                            setState(() {
                              isHabit = false;
                            });
                          }
                        }),
                    Text('할일'),
                  ],
                ),
                if (isHabit) habitDayOfWeekSelector(),
                if (!isHabit)
                  Text('할일을 실천할 날짜를 선택해주세요',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () async {
                      if (habitEndOrTaskDateInfo == noLimitNotation) {
                        habitEndOrTaskDateInfo =
                            await DateTimeFunction.selectDate(
                                habitEndOrTaskDateInfo, context);
                      } else {
                        habitEndOrTaskDateInfo = noLimitNotation;
                      }
                      setState(() {});
                    },
                    child: Text(
                      habitEndOrTaskDateInfo,
                      style: TextStyle(color: Colors.teal),
                    )),
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
                        color: Colors.teal,
                        onPressed: () {
                          if (title != '') {
                            List<String> aimDaysOfWeek = [];
                            if (isHabit) {
                              for (Day day in dayList) {
                                if (day.isSelected) {
                                  aimDaysOfWeek.add(day.name);
                                }
                              }

                              if (aimDaysOfWeek.length == 0) {
                                CustomDialogFunction.dialogFunction(
                                    context: context,
                                    isTwoButton: false,
                                    isLeftAlign: false,
                                    onPressed: () {},
                                    title: '요일 선택',
                                    text: '습관을 실천할 요일을 선택해 주세요',
                                    size: 'small');
                                return;
                              }
                            }
                            HivePlanApi.addHabit(
                                title: title,
                                isHabit: isHabit,
                                aimDaysOfWeek: aimDaysOfWeek,
                                habitEndOrTaskDateInfo: habitEndOrTaskDateInfo);
                            Navigator.pop(context);
                          }
                        },
                        title: '추가'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget habitDayOfWeekSelector() {
    return Column(
      children: [
        Text(
          '반복할 요일을 선택해주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
                value: isEveryDay,
                onChanged: (value) {
                  setState(() {
                    isEveryDay = value!;
                    isWeekDay = false;
                    for (Day day in dayList) {
                      day.isSelected = true;
                    }
                    if (value == false) {
                      for (Day day in dayList) {
                        day.isSelected = false;
                      }
                    }
                  });
                }),
            Text('매일'),
            Checkbox(
                value: isWeekDay,
                onChanged: (value) {
                  setState(() {
                    isWeekDay = value!;
                    isEveryDay = false;
                    for (Day day in dayList) {
                      if (day.name != '토' && day.name != '일') {
                        day.isSelected = true;
                      } else {
                        day.isSelected = false;
                      }
                    }
                    if (value == false) {
                      for (Day day in dayList) {
                        day.isSelected = false;
                      }
                    }
                  });
                }),
            Text('주중'),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 5,
            ),
            for (Day day in dayList) ...{
              GestureDetector(
                onTap: () {
                  setState(() {
                    day.click();
                    isEveryDay = false;
                    isWeekDay = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: day.isSelected ? Colors.teal : Colors.black,
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor:
                        day.isSelected ? Colors.teal : Colors.transparent,
                    child: Text(
                      day.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: day.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            },
            SizedBox(
              width: 5,
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '습관을 종료할 날짜를 선택해주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
