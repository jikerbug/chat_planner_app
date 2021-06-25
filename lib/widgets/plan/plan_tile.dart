import 'package:chat_planner_app/api_in_local/hive_record_api.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models/event.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/plan/plan_record_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanTile extends StatefulWidget {
  final bool isChecked;
  final String title;
  final int index;
  final String createdTime;
  final String type;
  final void Function() deleteFunction;
  final void Function(dynamic) checkFunction;

  PlanTile({
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
    return GestureDetector(
      child: SvgPicture.asset(
        //svg가 안되는 경우, svg파일에 null이라는 단어가 있는지 확인. 있다면 none으로 변경
        'assets/images/stamp_real_4.svg',
        color: Colors.grey,
        width: 35, height: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Data>(context, listen: false);
    if (widget.isChecked) {
      //initState에서 해주면 안됨(key가 같아서 객체로 취급되는듯)
      leadingWidget = donePlanLeading();
    } else {
      leadingWidget = notDonePlanLeading();
    }
    return GestureDetector(
      onTap: () {
        Map recordMap = HiveRecordApi.getRecordsMapOfPlan(widget.createdTime);
        Map<DateTime, List<Event>> eventSource = {};
        recordMap.forEach((key, value) {
          print(value.doneTimestamp);
          eventSource.putIfAbsent(
              DateTime.parse(value.doneTimestamp),
              () => [
                    Event(
                        '${DateTimeFunction.doneDateTimeString(value.doneTimestamp)}에 실천')
                  ]);
        });

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) => PlanRecordScreen(
              title: widget.title,
              eventSource: eventSource,
              createdTime: widget.createdTime,
              deleteFunction: widget.deleteFunction,
            ),
          ),
        );
      },
      //Material 없애면 화면 이상해짐
      child: ListTile(
        tileColor: Colors.transparent, //이거를 white로 하니까 화면 이상해졌었다!!
        leading: leadingWidget,
        title: widget.isChecked == false
            ? Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                if (isPromised) ...[
                  GestureDetector(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  ),
                ] else ...[
                  GestureDetector(
                    child: Icon(
                      Icons.pause_circle_outline,
                      color: Colors.grey,
                    ),
                    onTap: () {},
                  ),
                ],
                Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration:
                          widget.isChecked ? TextDecoration.lineThrough : null),
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
    );
  }
}
