import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/constants.dart';

class MessageSender extends StatefulWidget {
  MessageSender(
      {this.userId,
      this.friendUserId,
      this.chatRoomId,
      this.scrollDownCallback});

  final userId;
  final friendUserId;
  final chatRoomId;
  final scrollDownCallback;

  @override
  _MessageSenderState createState() => _MessageSenderState();
}

class _MessageSenderState extends State<MessageSender> {
  TextEditingController textEditingController = TextEditingController();
  late DateTime lastSentTime = DateTime.now().subtract(Duration(minutes: 5));
  //그냥 나갔다 들어와서 채팅치면 새로 시작하는 것도 낫배드

  bool checkIfMsgIsFirstTimeline(sendTime, lastSentTime) {
    if (lastSentTime == null) {
      return true;
    } else {
      String sendTimeFormatted =
          DateFormat('yyyy-MM-dd HH:mm').format(sendTime);
      String lastSentTimeFormatted =
          DateFormat('yyyy-MM-dd HH:mm').format(lastSentTime);
      if (sendTimeFormatted != lastSentTimeFormatted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String text = '';
    return Container(
      decoration: kMessageContainerDecoration,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  //maxLines: null : 여러줄 쓸 수 있게 해준다!
                  maxLines: null,
                  controller: textEditingController,
                  onChanged: (value) {
                    //Do something with the user input.
                    text = value;
                  },
                  decoration: kMessageTextFieldDecoration,
                ),
              ),
              FlatButton(
                minWidth: 50.0,
                onPressed: () async {
                  textEditingController.clear();
                  if (text != '') {
                    await FireStoreApi.sendDateBubbleIfLastSentDateIsNotToday(
                        widget.chatRoomId);
                    DateTime sendTime = DateTime.now();
                    bool isFirstTimeline =
                        checkIfMsgIsFirstTimeline(sendTime, lastSentTime);
                    FireStoreApi.sendMessage(
                        text, widget.userId, widget.chatRoomId, sendTime,
                        isFirstTimeline: isFirstTimeline);
                    lastSentTime = sendTime;
                    widget.scrollDownCallback();
                  }
                  setState(() {
                    text = '';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
