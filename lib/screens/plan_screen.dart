import 'package:chat_planner_app/functions/datetime_function.dart';
import 'package:chat_planner_app/modules/plan_list.dart';
import 'package:chat_planner_app/screens/bottom_sheet/plan_category_select.dart';
import 'package:flutter/material.dart';
import '../functions/custom_dialog_function.dart';

class InfoPanel extends StatefulWidget {
  @override
  _InfoPanelState createState() => _InfoPanelState();
}

class _InfoPanelState extends State<InfoPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isRewardDisplaySetting = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          child: (isRewardDisplaySetting)
              ? Text(
                  '보상에 76% 도달',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : Text(
                  '금일 하트 0개 획득',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
        ),
        SizedBox(
          width: 3.0,
        ),
        GestureDetector(
          onTap: () {
            CustomDialogFunction.dialogFunction(
                context: context,
                isTwoButton: false,
                isLeftAlign: true,
                onPressed: () {},
                title: (isRewardDisplaySetting) ? "보상 안내" : "하트 안내",
                text: (isRewardDisplaySetting)
                    ? '1주일동안의 목표를 달성하면\n치킨보상을 얻기로 선택하셨습니다.'
                        '\n목표달성 내용은 채팅방에 업로드됩니다.'
                        '\n\n습관을 모두 완료한 후에 \n보상을 즐기는 사진을 함께 공유하세요!'
                        '\n벌칙을 받게 되더라도 함께 공유해보세요!\n 다음번에 더 잘 실천하게 될 거에요'
                        '\n\n 실천현황\n스쿼트 100회 : 5회/주 7회\n독서 30분 : 3회/주 5회'
                    : '1. 체크박스를 체크하여 계획의 실천을 표시합니다. '
                        '\n\n2. 계획이 등록된 채팅방에 메시지가 발송됩니다.'
                        '\n\n3. 메시지에는 하트버튼이 표시됩니다. '
                        '\n\n4. 채팅방에 입장한 다른 사용자는 버튼을 눌러 칭찬의 표시를 할 수 있습니다.'
                        '\n\n5. 이때 계획의 좌측에 하트 아이콘이 생기고 이를 눌러 하트를 적립할 수 있습니다.'
                        '\n\n6. 동일한 과정이, 계획의 플레이버튼을 눌러 실천을 약속할때에도 일어납니다.',
                size: 'max');
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Image.asset(
              'assets/images/question.png',
              width: 30,
              height: 30,
              fit: BoxFit.scaleDown,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class PlanScreen extends StatefulWidget {
  static const String id = 'task_screen';

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late String selectedDay;
  late DateTime nowSyncedAtReload;
  @override
  void initState() {
    super.initState();
    nowSyncedAtReload = DateTime.now();
    selectedDay = DateTimeFunction.getTodayOfWeek(nowSyncedAtReload);
  }

  @override
  Widget build(BuildContext context) {
    nowSyncedAtReload = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            InfoPanel(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 5,
                ),
                for (String dayCategory
                    in DateTimeFunction.dayListForPlanScreen) ...{
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDay = dayCategory;
                      });
                    },
                    child: Material(
                      color: (selectedDay == dayCategory)
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.0),
                      ),
                      elevation: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Text(
                          dayCategory,
                          style: TextStyle(
                              color: (selectedDay == dayCategory)
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    ),
                  )
                },
                SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ))),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => PlanCategorySelect(),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(new Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.green,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '카테고리 - 전체',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          print('구현타입1 : 버튼 클릭시 1주일 전 기록으로 이동!, 다시클릭하면 돌아온다.');
                          print(
                              '구현타입2 : 버튼 클릭시 전체 습관의 전체 실천 기록을 한눈에 볼 수 있다.(습관 loop 처럼)');
                        },
                        child: Text(
                          '${DateTimeFunction.todayDateString(selectedDay, nowSyncedAtReload)}',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: PlanList(selectedDay, nowSyncedAtReload)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
