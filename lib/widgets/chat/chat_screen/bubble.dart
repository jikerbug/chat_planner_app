import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_planner_app/screens/profile_view_screen.dart';

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
      required this.isLastMessage,
      required this.friendProfileUrl});

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
  final String friendProfileUrl;

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
        widget.type == 'chat' ||
        widget.type == 'gift') {
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
                      : (widget.friendProfileUrl == '' ||
                              widget.friendProfileUrl == "no_profile_image")
                          ? [
                              Icon(Icons.accessibility,
                                  size: 24.0, color: Colors.black),
                              Text(
                                widget.sender,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ]
                          : [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              widget.friendProfileUrl)),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, ProfileViewScreen.id,
                                            arguments: {
                                              'profileUrl':
                                                  widget.friendProfileUrl
                                            });
                                      }),
                                  Text(
                                    widget.sender,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              )
                            ],
            ),
            if (widget.type == 'add') ...[
              Material(
                elevation: 50.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundImage: AssetImage("images/promise.jpg"),
                  //해당 이미지는 저작권 문제 없기는 하지만 약간의 조건이 있는듯하다
                  //참고링크 : https://www.freepik.com/free-vector/hand-drawn-pinky-promise-concept_2721746.htm#page=2&query=promise&position=34
                ),
              ),
            ] else if (widget.type == 'gift') ...[
              Material(
                child: Image.asset(
                  "images/gift_1.png",
                  scale: 2.0,
                ),
                //해당 이미지는 저작권 문제 없기는 하지만 약간의 조건이 있는듯하다
                //참고링크 : https://www.freepik.com/free-vector/hand-drawn-pinky-promise-concept_2721746.htm#page=2&query=promise&position=34
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
                        elevation: 4.0,
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
            if (widget.isLastMessage) ...[
              SizedBox(
                height: 5.5,
              ),
            ]
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
                  : (widget.friendProfileUrl == '' ||
                          widget.friendProfileUrl == "no_profile_image")
                      ? [
                          Icon(Icons.accessibility,
                              size: 24.0, color: Colors.black),
                          Text(
                            widget.sender,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ]
                      : [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          widget.friendProfileUrl)),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ProfileViewScreen.id,
                                        arguments: {
                                          'profileUrl': widget.friendProfileUrl
                                        });
                                  }),
                              Text(
                                widget.sender,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          )
                        ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
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
                        elevation: 4.0,
                        borderRadius: BorderRadius.only(
                          topLeft: widget.topLeftRadius,
                          topRight: widget.topRightRadius,
                          bottomRight: Radius.circular(19.0),
                          bottomLeft: Radius.circular(19.0),
                        ),
                        color: chatColor,
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
            if (widget.isLastMessage) ...[
              SizedBox(
                height: 5.5,
              ),
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
            )
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
                      : (widget.friendProfileUrl == '' ||
                              widget.friendProfileUrl == "no_profile_image")
                          ? [
                              Icon(Icons.accessibility,
                                  size: 24.0, color: Colors.black),
                              Text(
                                widget.sender,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ]
                          : [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              widget.friendProfileUrl)),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, ProfileViewScreen.id,
                                            arguments: {
                                              'profileUrl':
                                                  widget.friendProfileUrl
                                            });
                                      }),
                                  Text(
                                    widget.sender,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              )
                            ],
                ),
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
