import 'package:chat_planner_app/screens/chat/cheer_message_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  Bubble(
      {required this.text,
      required this.sender,
      required this.isMe,
      required this.type,
      required this.time,
      required this.topLeftRadius,
      required this.topRightRadius,
      required this.isFirstTimeline,
      required this.isLastTimeline,
      required this.isLastMessage});

  final String text;
  final String sender;
  final bool isMe;
  final String type;
  final String time;
  final Radius topLeftRadius;
  final Radius topRightRadius;
  final bool isFirstTimeline;
  final bool isLastTimeline;
  final bool isLastMessage;

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  final double messageFontSize = 16.0;

  final double messageBubbleGap = 2.5;
  bool isHearted = false;

  @override
  Widget build(BuildContext context) {
    String addTimeDecorator = '';

    if (widget.type == 'guide' ||
        widget.type == 'add' ||
        widget.type == 'chat') {
      Color chatColor;
      Color fontColor;
      if (widget.type == 'add') {
        chatColor = Colors.teal;
        fontColor = Colors.white;
        addTimeDecorator = ''; //' 등록';
      } else if (widget.type == 'guide') {
        chatColor = Colors.lightGreen[50]!;
        fontColor = Colors.black;
      } else {
        chatColor = widget.isMe ? Colors.green : Colors.white;
        fontColor = widget.isMe ? Colors.white : Colors.black;
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (widget.isFirstTimeline && !widget.isMe) ...[
              SizedBox(
                height: 5.5,
              )
            ],
            Row(
              children: widget.isMe || !widget.isFirstTimeline
                  ? []
                  : (widget.sender == '실천요정')
                      ? [
                          Icon(Icons.auto_fix_high,
                              size: 24.0, color: Colors.black),
                          Text(
                            widget.sender,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ]
                      : [
                          Icon(Icons.accessibility,
                              size: 24.0, color: Colors.black),
                          Text(
                            widget.sender,
                            style: TextStyle(fontSize: 12.0),
                          )
                        ],
            ),
            if (widget.type == 'add') ...[
              Material(
                elevation: 50.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundImage: AssetImage("assets/images/promise.jpg"),
                  //해당 이미지는 저작권 문제 없기는 하지만 약간의 조건이 있는듯하다
                  //참고링크 : https://www.freepik.com/free-vector/hand-drawn-pinky-promise-concept_2721746.htm#page=2&query=promise&position=34
                ),
              ),
            ],
            Padding(
              padding: (widget.type == 'add')
                  ? EdgeInsets.only(
                      top: 0.0, bottom: 4.0, left: 4.0, right: 4.0)
                  : EdgeInsets.symmetric(
                      vertical: messageBubbleGap, horizontal: 4.0),
              child: Row(
                  mainAxisAlignment: widget.isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.isMe ? widget.time + addTimeDecorator : '',
                      style: TextStyle(
                          fontSize:
                              widget.isLastTimeline || (widget.type == 'add')
                                  ? 12.0
                                  : 0.0),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        elevation: 2.0,
                        color: chatColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22.0),
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                  color: fontColor, fontSize: messageFontSize),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.isMe ? '' : widget.time + addTimeDecorator,
                      style: TextStyle(
                          fontSize:
                              widget.isLastTimeline || (widget.type == 'add')
                                  ? 12.0
                                  : 0.0),
                    ),
                  ]),
            ),
          ],
        ),
      );
    } else if (widget.type == 'done') {
      Color chatColor;
      Color fontColor;
      if (widget.type == 'add') {
        chatColor = Colors.teal;
        fontColor = Colors.white;
        addTimeDecorator = ' 등록';
      } else if (widget.type == 'guide') {
        chatColor = Colors.lightGreen[50]!;
        fontColor = Colors.black;
      } else {
        chatColor = widget.isMe ? Colors.green : Colors.white;
        fontColor = widget.isMe ? Colors.white : Colors.black;
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment:
              widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              children: widget.isMe || !widget.isFirstTimeline
                  ? []
                  : [
                      Icon(Icons.accessibility,
                          size: 24.0, color: Colors.black),
                      Text(
                        widget.sender,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 3 / 5,
              height: MediaQuery.of(context).size.width * 35 / 100,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 2 / 25),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      '${widget.text}\n${widget.time}',
                      style: TextStyle(
                        color: widget.isMe ? Colors.black : Colors.black,
                        fontSize: messageFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage("assets/images/done_card.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            if (widget.isFirstTimeline && !widget.isMe) ...[
              SizedBox(
                height: 5.5,
              )
            ],
            Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Icon(Icons.photo_camera),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isHearted = true;
                    });
                    String planType;
                    if (widget.type == 'done') {
                      planType = '실천';
                    } else if (widget.type == 'add') {
                      planType = '약속';
                    } else {
                      planType = 'no_way';
                    }
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CheerMessageSelect(
                        plan: widget.text.split('완료')[0].trim(),
                        planType: planType,
                        cheerUserId: widget.sender,
                      ),
                    );
                  },
                  child: isHearted
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_outline,
                          color: Colors.black,
                        ),
                ),
              ],
            ),
            if (widget.isLastMessage) ...[
              SizedBox(
                height: 5.5,
              ),
            ],
          ],
        ),
      );

      return Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                    children: widget.isMe
                        ? []
                        : [
                            Icon(Icons.accessibility,
                                size: 24.0, color: Colors.black),
                            Text(
                              widget.sender,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ]),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    width: 207,
                    height: 207,
                    child: Padding(
                      padding: EdgeInsets.all(45.0),
                      child: Center(
                        child: Text(
                          '${widget.text}\n(${widget.time})',
                          style: TextStyle(
                            color: widget.isMe ? Colors.black : Colors.black,
                            fontSize: messageFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/mcoin_edited.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
