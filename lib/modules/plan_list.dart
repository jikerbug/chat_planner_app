import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/api_in_local/hive_plan_api.dart';
import 'package:chat_planner_app/api_in_local/hive_record_api.dart';
import 'package:chat_planner_app/api_in_local/hive_user_api.dart';
import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/plan_model.dart';
import 'package:chat_planner_app/models_hive/record_model.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/providers/data.dart';
import '../constants.dart';
import '../widgets/plan/plan_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlanList extends StatefulWidget {
  PlanList(this.selectedDay, this.nowSyncedAtReload,
      {this.chatRoomIdCategory = 'all'});

  final String selectedDay;
  final DateTime nowSyncedAtReload;
  final chatRoomIdCategory;
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
                Text('????????? ??????????????????'),
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
                  child: Text('???????????? ???????????? ????????????.'),
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

  Widget getPlanTile(box, index, PlanModel item) {
    if (widget.selectedDay !=
            DateTimeFunction.getTodayOfWeek(widget.nowSyncedAtReload) &&
        widget.selectedDay != '??????') {
      DateTime selectedDateTime = DateTimeFunction.getDateTimeOfSelectedDate(
          widget.selectedDay, widget.nowSyncedAtReload);
      if (selectedDateTime.compareTo(widget.nowSyncedAtReload) > 0) {
        return futurePlanTile(box, index, item);
      } else if (selectedDateTime.compareTo(widget.nowSyncedAtReload) < 0) {
        bool isChecked = false;
        Box recordBox;
        if (item.isHabit) {
          recordBox = Hive.box<RecordModel>(item.createdTime);
        } else {
          recordBox = Hive.box<RecordModel>(kTodoRecordBoxName);
        }
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
    if (widget.chatRoomIdCategory != 'all') {
      if (item.selectedChatRoomId != widget.chatRoomIdCategory) {
        return true;
      }
    }

    if (widget.selectedDay != '??????') {
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
      isHabit: item.isHabit,
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
              title: '?????? ??????',
              text: '????????? ??????????????????.',
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
    //????????? ?????? ????????? ??? ??????.
    return PlanTile(
      isHabit: item.isHabit,
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
                title: '?????? ??????',
                text: '????????? ????????? ??????????????? ?????? 10?????? ???????????????.\n?????????????????????????',
                size: 'small');
          } else {
            CustomDialogFunction.dialog(
                context: context,
                isTwoButton: false,
                isLeftAlign: false,
                onPressed: () {},
                title: '?????? ??????',
                text: '????????? ??????????????? ????????? ??? ????????????.',
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
              title: '?????? ?????? ??????',
              text: '?????? ????????? ????????? ????????? ????????? ??? ????????????.',
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
      isHabit: item.isHabit,
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
                title: '?????? ?????? ??????',
                text: '????????? ?????????????????????.\n??? ????????? ??? ????????? ??????????????????',
                size: 'small');
          } else {
            HivePlanApi.checkPlanDone(box, index, item);
            HiveRecordApi.addRecord(
                item: item, doneTimestamp: DateTime.now().toString());
            String chatRoomId = item.selectedChatRoomId;
            print('chatRoomId');
            print(chatRoomId);
            if (chatRoomId != 'none') {
              FireStoreApi.sendDoneMessages(
                item.title,
                User().userId,
                chatRoomId,
              );

              ChatRoomEnterFunctions.chatRoomEnterProcess(
                  context, chatRoomId, '????????? ??????');
            }
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
              title: '?????? ?????? ??????',
              text: '????????? ??????????????? ?????? 10?????? ???????????????.\n????????? ?????????????????????????',
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
