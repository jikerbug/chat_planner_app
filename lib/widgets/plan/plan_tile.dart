import 'package:chat_planner_app/api_in_local/hive_record_api.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models/event.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/plan/plan_record_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanTile extends StatefulWidget {
  final bool isHabit;
  final bool isChecked;
  final String title;
  final int index;
  final String createdTime;
  final String type;
  final void Function() deleteFunction;
  final void Function(dynamic) checkFunction;

  PlanTile({
    required this.isHabit,
    required this.isChecked,
    required this.title,
    required this.index,
    required this.createdTime,
    required this.type,
    required this.deleteFunction,
    required this.checkFunction,
  });

  @override
  _PlanTileState createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  bool isPromised = true;
  late Widget leadingWidget;

  Widget donePlanLeading() {
    return GestureDetector(child: Icon(Icons.check), onTap: () {});
  }

  Widget notDonePlanLeading() {
    if (isPromised)
      return GestureDetector(
        child: Icon(
          Icons.play_circle_outline,
          color: Colors.grey,
        ),
        onTap: () {
          print('약속메시지 보내기');
        },
      );
    else
      return GestureDetector(
        child: Icon(
          Icons.pause_circle_outline,
          color: Colors.grey,
        ),
        onTap: () {},
      );
  }

  Widget doneCheckToolBackGround() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isChecked) {
      //initState에서 해주면 안됨(key가 같아서 객체로 취급되는듯)
      leadingWidget = donePlanLeading();
    } else {
      leadingWidget = notDonePlanLeading();
    }
    return Slidable(
      showAllActionsThreshold: 0.8,
      fastThreshold: 0.1,
      actions: [],
      secondaryActions: [
        GestureDetector(
            onTap: () {
              print('camera');
            },
            child: Icon(Icons.camera_alt, color: Colors.black)),
        GestureDetector(
            onTap: () {
              print('stopwatch');
            },
            child: Icon(Icons.timer, color: Colors.black))
      ],
      actionPane: SlidableScrollActionPane(),
      key: Key(widget.createdTime),
      child: GestureDetector(
        onTap: () {
          Map recordMap = HiveRecordApi.getRecordsMapOfPlan(
              widget.createdTime, widget.isHabit);

          Map<DateTime, List<Event>> eventSource = {};
          DateTime? dateKey;
          recordMap.forEach((key, value) {
            String description;
            if (widget.isHabit) {
              description =
                  '${DateTimeFunction.doneDateTimeString(value.doneTimestamp)}에 실천';
            } else {
              description =
                  '${value.title}\n${DateTimeFunction.doneDateTimeString(value.doneTimestamp)}에 실천';
            }
            print(value.doneTimestamp);

            dateKey = DateTime.parse(value.doneTimestamp);

            if (eventSource.containsKey(dateKey)) {
              eventSource[dateKey]!.add(Event(description));
            } else {
              eventSource[dateKey!] = [Event(description)];
            }
          });
          print('start');
          eventSource.forEach((key, value) {
            print(key);
            print(value);
          });

          BuildContext mainRouteContext =
              Provider.of<Data>(context, listen: false).mainRouteContext;

          Navigator.push(
            mainRouteContext,
            CupertinoPageRoute(
              builder: (BuildContext context) => PlanRecordScreen(
                title: widget.isHabit ? widget.title : '할일 실천 기록',
                eventSource: eventSource,
                createdTime: widget.createdTime,
                deleteFunction: widget.deleteFunction,
              ),
            ),
          );
        },
        //Material 없애면 화면 이상해짐
        child: ListTile(
          dense: true,
          tileColor: Colors.transparent, //이거를 white로 하니까 화면 이상해졌었다!!
          leading: leadingWidget,
          title: widget.isChecked == false
              ? Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        decoration: widget.isChecked
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                ])
              : Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 17.0,
                      decoration:
                          widget.isChecked ? TextDecoration.lineThrough : null),
                ),
          trailing: Checkbox(
            value: widget.isChecked,
            onChanged: (value) {
              widget.checkFunction(value);
            },
          ),
        ),
      ),
    );
  }
}
