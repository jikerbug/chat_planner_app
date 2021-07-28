import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheerTile extends StatefulWidget {
  final String plan;
  final String planType;
  final DateTime time;
  final String senderNickname;
  final String type;

  CheerTile({
    required this.plan,
    required this.planType,
    required this.time,
    required this.senderNickname,
    required this.type,
  });

  @override
  _CheerTileState createState() => _CheerTileState();
}

class _CheerTileState extends State<CheerTile> {
  bool isHearted = false;
  bool checkBottomConsonant(String input) {
    return (input.runes.last - 0xAC00) % 28 != 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEul = checkBottomConsonant(widget.planType);
    String postfix;
    if (isEul) {
      postfix = '을';
    } else {
      postfix = '를';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListTile(
        tileColor: Colors.transparent, //이거를 white로 하니까 화면 이상해졌었다!!
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: widget.senderNickname,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '님이 '),
              TextSpan(
                  text: widget.plan + ' ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 17.0,
                  )),
              TextSpan(
                  text: widget.planType,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: postfix + ' '),
              TextSpan(
                  text: widget.type,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '했어요!'),
            ],
          ),
        ),
        trailing: Column(
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    isHearted = true;
                  });
                },
                child: isHearted
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_outline)),
            SizedBox(
              height: 5.0,
            ),
            Text(DateTimeFunction.lastSentTimeFormatter(widget.time)),
          ],
        ),
      ),
    );
  }
}
