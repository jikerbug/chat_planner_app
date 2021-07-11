import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/modules/plan_list.dart';
import 'package:chat_planner_app/widgets/plan/info_panel.dart';
import 'plan_chat_room_select.dart';
import 'package:chat_planner_app/widgets/thin_button.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  static const String id = 'plan_screen';

  PlanScreen({required this.fabFunc});
  final Function fabFunc;

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late String selectedDay;
  late DateTime nowSyncedAtReload;
  String selectedChatRoomId = 'none';
  String selectedChatRoomName = '없음';

  @override
  void initState() {
    super.initState();
    nowSyncedAtReload = DateTime.now();
    selectedDay = DateTimeFunction.getTodayOfWeek(nowSyncedAtReload);

    Future.delayed(Duration.zero, () {
      widget.fabFunc(PlanScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    nowSyncedAtReload = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            InfoPanel('heart'),
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
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 18,
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
            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                    ThinButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => PlanChatRoomSelect(
                              chatRoomSelectCallback:
                                  (chatRoomId, chatRoomName) {
                                setState(() {
                                  selectedChatRoomId = chatRoomId;
                                  selectedChatRoomName = chatRoomName;
                                });
                                return 'success';
                              },
                              callerScreen: PlanScreen.id),
                        );
                      },
                      title: '채팅방 - $selectedChatRoomName',
                      color: Colors.green,
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
