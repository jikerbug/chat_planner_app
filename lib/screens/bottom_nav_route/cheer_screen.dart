import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/modules/cheer_list.dart';
import 'package:chat_planner_app/widgets/plan/info_panel.dart';
import 'package:flutter/material.dart';

class CheerScreen extends StatefulWidget {
  static const String id = 'cheer_screen';

  CheerScreen({required this.fabFunc});
  final Function fabFunc;

  @override
  _CheerScreenState createState() => _CheerScreenState();
}

class _CheerScreenState extends State<CheerScreen> {
  late String selectedDay;
  late DateTime nowSyncedAtReload;
  String selectedChatRoomId = 'all';
  String selectedChatRoomName = '전체';

  @override
  void initState() {
    super.initState();
    nowSyncedAtReload = DateTime.now();
    selectedDay = DateTimeFunction.getTodayOfWeek(nowSyncedAtReload);

    Future.delayed(Duration.zero, () {
      widget.fabFunc(CheerScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    nowSyncedAtReload = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InfoPanel('heart_total'),
        Container(
          height: MediaQuery.of(context).size.width / 9,
          child: Text(
            '응원 1번 / 칭찬 1번 받았어요',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              color: Colors.white,
            ),
            child: CheerList(),
          ),
        ),
      ],
    );
  }
}
