import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/api_in_local/hive_plan_api.dart';
import 'package:chat_planner_app/api_in_local/hive_record_api.dart';
import 'package:chat_planner_app/api_in_local/hive_user_api.dart';
import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/plan_model.dart';
import 'package:chat_planner_app/models_hive/record_model.dart';
import 'package:chat_planner_app/providers/data.dart';
import '../widgets/plan/plan_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlanList extends StatefulWidget {
  PlanList(this.selectedDay, this.nowSyncedAtReload);

  final String selectedDay;
  final DateTime nowSyncedAtReload;
  @override
  _PlanListState createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  @override
  void initState() {
    super.initState();
    final planBox = Hive.box<PlanModel>('plan');
    final userId = Provider.of<Data>(context, listen: false).userId;
    HiveUserApi.refreshPlanByLastCheckInDate(userId, DateTime.now(), planBox);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Data>(context, listen: false).userId;

    return ValueListenableBuilder(
        valueListenable: Hive.box<PlanModel>('plan').listenable(),
        builder: (context, Box<PlanModel> box, child) {
          if (box.length == 0) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/heart_flower_2.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.fill,
                  color: Colors.black,
                ),
                Text('계획을 추가해주세요'),
              ],
            ));
          }
          return ReorderableListView.builder(
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) {
              HivePlanApi.reorderPlanData(box, oldIndex, newIndex);
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              print('builder : box.keys : ${box.keys}');
              final item = box.getAt(index);

              if (item == null) {
                return Container(
                  child: Text('아이템이 존재하지 않습니다.'),
                );
              }
              bool isInvisible = isItemInvisibleCondition(item);
              if (isInvisible) {
                return Container(
                  key: ValueKey(item),
                );
              }

              return ReorderableDelayedDragStartListener(
                key: ValueKey(item),
                index: index,
                child: getPlanTile(box, index, item),
              );
            },
            itemCount: box.length,
          );
        });
  }

  Widget getPlanTile(box, index, item) {
    if (widget.selectedDay !=
            DateTimeFunction.getTodayOfWeek(widget.nowSyncedAtReload) &&
        widget.selectedDay != '전체') {
      DateTime selectedDateTime = DateTimeFunction.getDateTimeOfSelectedDate(
          widget.selectedDay, widget.nowSyncedAtReload);
      if (selectedDateTime.compareTo(widget.nowSyncedAtReload) > 0) {
        return futurePlanTile(box, index, item);
      } else if (selectedDateTime.compareTo(widget.nowSyncedAtReload) < 0) {
        bool isChecked = false;

        Box recordBox = Hive.box<RecordModel>(item.createdTime);
        recordBox.values.where((element) {
          return DateTimeFunction.isSameDate(
              element.doneTimestamp, selectedDateTime.toString());
        }).forEach((element) {
          print('there is done record');
          isChecked = true;
        });
        if (selectedDateTime.weekday ==
            widget.nowSyncedAtReload.subtract(Duration(days: 1)).weekday) {
          return pastPlanTile(
              box, index, item, 'yesterday', isChecked, selectedDateTime);
        }
        return pastPlanTile(box, index, item, '', isChecked, selectedDateTime);
      }
    }
    return activatedPlanTile(box, index, item);
  }

  bool isItemInvisibleCondition(PlanModel item) {
    if (widget.selectedDay != '전체') {
      DateTime selectedDateTime = DateTimeFunction.getDateTimeOfSelectedDate(
          widget.selectedDay, widget.nowSyncedAtReload);
      print(
          'selectedDateTime: $selectedDateTime / selectedDay : ${widget.selectedDay}');

      if (item.isHabit) {
        bool isSelectedDayEqualsAimDayOfWeek = false;
        for (String dayName in item.aimDaysOfWeek) {
          if (dayName == widget.selectedDay) {
            isSelectedDayEqualsAimDayOfWeek = true;
            break;
          }
        }
        if (!isSelectedDayEqualsAimDayOfWeek) {
          return true;
        }
      } else {
        if (item.planEndDate == DateTimeFunction.noLimitNotation) {
          if (DateTimeFunction.getTodayOfWeek(widget.nowSyncedAtReload) !=
              widget.selectedDay) {
            return true;
          }
        } else {
          if (DateTimeFunction.dateTimeToDateString(selectedDateTime) !=
              item.planEndDate) {
            return true;
          }
        }
      }
    }
    return false;
  }

  Widget futurePlanTile(box, index, item) {
    return PlanTile(
      deleteFunction: () {
        HivePlanApi.deletePlanData(box, index);
      },
      checkFunction: (value) {
        if (value == true) {
          CustomDialogFunction.dialog(
              context: context,
              isTwoButton: false,
              isLeftAlign: false,
              onPressed: () {},
              title: '실천 안내',
              text: '당일에 실천해주세요.',
              size: 'small');
        }
      },
      isChecked: false,
      title: item.title,
      index: index,
      createdTime: item.createdTime,
      type: 'future',
    );
  }

  Widget pastPlanTile(box, index, item, type, isChecked, selectedDateTime) {
    //하트를 써서 체크할 수 있다.
    return PlanTile(
      deleteFunction: () {
        HivePlanApi.deletePlanData(box, index);
      },
      checkFunction: (value) {
        if (value == true) {
          if (type == 'yesterday') {
            CustomDialogFunction.dialog(
                context: context,
                isTwoButton: true,
                isLeftAlign: false,
                onPressed: () {
                  HiveRecordApi.addRecord(
                    item: item,
                    doneTimestamp: selectedDateTime.toString(),
                  );
                  setState(() {});
                },
                title: '실천 안내',
                text: '어제의 계획을 실천하려면 하트 10개가 필요합니다.\n실천하시겠습니까?',
                size: 'small');
          } else {
            CustomDialogFunction.dialog(
                context: context,
                isTwoButton: false,
                isLeftAlign: false,
                onPressed: () {},
                title: '실천 안내',
                text: '어제의 계획까지만 실천할 수 있습니다.',
                size: 'small');
          }
        } else {
          CustomDialogFunction.dialog(
              context: context,
              isTwoButton: false,
              isLeftAlign: false,
              onPressed: () {
                HivePlanApi.unCheckPlan(box, index, item);
              },
              title: '실천 취소 안내',
              text: '당일 실천한 계획만 실천을 취소할 수 있습니다.',
              size: 'small');
        }
      },
      isChecked: isChecked,
      title: item.title,
      index: index,
      createdTime: item.createdTime,
      type: 'past',
    );
  }

  Widget activatedPlanTile(box, index, PlanModel item) {
    return PlanTile(
      deleteFunction: () {
        HivePlanApi.deletePlanData(box, index);
      },
      checkFunction: (value) {
        if (value == true) {
          if (widget.nowSyncedAtReload.day != DateTime.now().day) {
            CustomDialogFunction.dialog(
                context: context,
                isTwoButton: false,
                isLeftAlign: false,
                onPressed: () {},
                title: '날짜 변경 안내',
                text: '날짜가 변경되었습니다.\n앱 재시작 후 실천을 표시해주세요',
                size: 'small');
          } else {
            HivePlanApi.checkPlanDone(box, index, item);
            HiveRecordApi.addRecord(
                item: item, doneTimestamp: DateTime.now().toString());
            String chatRoomId = item.selectedChatRoomId;
            print('chatRoomId');
            print(chatRoomId);
            FireStoreApi.sendDoneMessages(item.title, 'mindnetworkcorp@gmail',
                chatRoomId, 'mindnetworkcorp@gmail');

            ChatRoomEnterFunctions.chatRoomEnterProcess(
                context, chatRoomId, '나와의 채팅');
          }
        } else {
          CustomDialogFunction.dialog(
              context: context,
              isTwoButton: true,
              isLeftAlign: false,
              onPressed: () {
                HivePlanApi.unCheckPlan(box, index, item);
                HiveRecordApi.deleteRecordOfToday(
                    item: item,
                    deleteTimestamp: widget.nowSyncedAtReload.toString());
              },
              title: '실천 취소 안내',
              text: '실천을 취소하려면 하트 10개가 필요합니다.\n실천을 취소하시겠습니까?',
              size: 'small');
        }
      },
      isChecked: item.isChecked,
      title: item.title,
      index: index,
      createdTime: item.createdTime,
      type: 'activated',
    );
  }
}
