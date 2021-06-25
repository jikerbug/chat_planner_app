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
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'plan_category_select.dart';
import 'package:chat_planner_app/widgets/circle_border_box.dart';
import 'package:chat_planner_app/widgets/rounded_button.dart';
import 'package:chat_planner_app/widgets/thin_button.dart';
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
  bool isMonWedFri = false;
  bool isTueThuSat = false;
  String noLimitNotation = DateTimeFunction.noLimitNotation;
  late String planEndDateInfo = noLimitNotation;
  String selectedChatRoomId = 'none';
  String selectedChatRoomName = '없음';

  Widget sameGroupGapBox() => SizedBox(
        height: 5.0,
      );
  Widget otherGroupGapBox() => SizedBox(
        height: 20.0,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 9 / 10,
      child: SafeArea(
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
                otherGroupGapBox(),
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
                otherGroupGapBox(),
                if (isHabit) habitDayOfWeekSelector(),
                if (!isHabit)
                  Text('할일을 실천할 날짜를 선택해주세요',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                sameGroupGapBox(),
                TextButton(
                    onPressed: () async {
                      if (planEndDateInfo == noLimitNotation) {
                        planEndDateInfo = await DateTimeFunction.selectDate(
                            planEndDateInfo, context);
                      } else {
                        planEndDateInfo = noLimitNotation;
                      }
                      setState(() {});
                    },
                    child: Text(
                      planEndDateInfo,
                      style: TextStyle(color: Colors.teal),
                    )),
                otherGroupGapBox(),
                Text('계획을 공유할 채팅방과 카테고리를 선택해주세요',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                sameGroupGapBox(),
                ThinButton(
                    onPressed: () {
                      User user = User();
                      String userId = user.userId;
                      print('야야야 $userId');
                      showModalBottomSheet(
                        isScrollControlled:
                            true, //full screen으로 modal 쓸 수 있게 해준다.
                        context: context,
                        builder: (context) => PlanCategorySelect(
                          chatRoomCallback: (chatRoomId, chatRoomName) {
                            setState(() {
                              selectedChatRoomId = chatRoomId;
                              selectedChatRoomName = chatRoomName;
                            });
                            return 'success';
                          },
                          userId: userId,
                        ),
                      );
                    },
                    title: '카테고리 - 전체 / 채팅방 - $selectedChatRoomName',
                    color: Colors.teal),
                otherGroupGapBox(),
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
                                CustomDialogFunction.dayOfWeekNotSelected(
                                    context);
                                return;
                              }
                            }
                            HivePlanApi.addPlan(
                              title: title,
                              isHabit: isHabit,
                              aimDaysOfWeek: aimDaysOfWeek,
                              planEndDateInfo: planEndDateInfo,
                              selectedChatRoomId: selectedChatRoomId,
                            );
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
        sameGroupGapBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
                value: isEveryDay,
                onChanged: (value) {
                  setState(() {
                    isEveryDay = value!;
                    isWeekDay = false;
                    isMonWedFri = false;
                    isTueThuSat = false;
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
                    isMonWedFri = false;
                    isTueThuSat = false;
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
            Checkbox(
                value: isMonWedFri,
                onChanged: (value) {
                  setState(() {
                    isMonWedFri = value!;
                    isWeekDay = false;
                    isEveryDay = false;
                    isTueThuSat = false;
                    for (Day day in dayList) {
                      if (day.name == '월' ||
                          day.name == '수' ||
                          day.name == '금') {
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
            Text('월수금'),
            Checkbox(
                value: isTueThuSat,
                onChanged: (value) {
                  setState(() {
                    isTueThuSat = value!;
                    isWeekDay = false;
                    isMonWedFri = false;
                    isEveryDay = false;
                    for (Day day in dayList) {
                      if (day.name == '화' ||
                          day.name == '목' ||
                          day.name == '토') {
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
            Text('화목토'),
          ],
        ),
        sameGroupGapBox(),
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
                child: CircleBorderBox(
                  radius: -1.0,
                  title: day.name,
                  textColor: day.isSelected ? Colors.white : Colors.black,
                  backGroundColor:
                      day.isSelected ? Colors.teal : Colors.transparent,
                  borderColor: day.isSelected ? Colors.teal : Colors.black,
                ),
              )
            },
            SizedBox(
              width: 5,
            ),
          ],
        ),
        otherGroupGapBox(),
        Text(
          '습관을 종료할 날짜를 선택해주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
