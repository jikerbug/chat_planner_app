import 'package:chat_planner_app/api/firebase_chat_api.dart';
import 'package:chat_planner_app/api_in_local/hive_chat_api.dart';
import 'package:flutter/material.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/modules/message_stream.dart';
import 'package:chat_planner_app/widgets/chat/chat_screen/done_count_fab.dart';
import 'package:chat_planner_app/widgets/chat/chat_screen/message_sender.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String text;
  int coinCount = 0;
  int myCoinCount = 0;
  int friendCoinCount = 0;
  late String chatRoomId;
  late String chatRoomName;
  String friendUserId = '';
  String userId = '';
  String friendNickname = '';
  String friendProfileUrl = '';
  var messageStream = MessageStream('', '', '', '', '');

  @override
  void initState() {
    super.initState();

    Function myCoinCallback = (getCoinCount) {
      setState(() {
        myCoinCount = getCoinCount;
        coinCount = myCoinCount + friendCoinCount;
      });
    };
    Function friendCoinCallback = (getCoinCount) {
      setState(() {
        friendCoinCount = getCoinCount;
        coinCount = myCoinCount + friendCoinCount;
      });
    };

    //상대방의 코인 적립개수를 보는 로직
    //InitState이후에 argument를 사용할 수 있다...!!
    Future.delayed(Duration.zero, () async {
      //메시지스트림을 위해 불러와야하는 놈들
      //이놈들을 포함한 다른 놈들은 build에서 불러오면 된다.
      Map argument = ModalRoute.of(context)!.settings.arguments as Map;
      userId = argument['userId'];
      chatRoomId = argument['chatRoomId'];

      messageStream = MessageStream(
          userId, chatRoomId, friendNickname, friendUserId, friendProfileUrl);
      setState(() {});
    });
  }

  @override
  void dispose() {
    //어차피 변경은 mainRouteScreen으로 돌아올때 일어난다 -> 입장할때 미리 바꿔줄 필요 x
    FirebaseChatApi.chatRoomStateChangeIdentified(userId);
    super.dispose();
  }

  void handleAppBarMenuClick(String value) {
    switch (value) {
      case '채팅방 나가기':
        print("채팅방 나가기?");
        CustomDialogFunction.dialog(
            isLeftAlign: false,
            context: context,
            isTwoButton: true,
            onPressed: () {
              HiveChatApi.exitChatRoom(chatRoomId);
              Navigator.pop(context);
            },
            title: "채팅방 나가기",
            text: '실천친구와의 매칭이 종료됩니다.\n채팅방을 나가시겠습니까?',
            size: 'middle');
        break;
      case '채팅방 정보 보기':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map argument = ModalRoute.of(context)!.settings.arguments as Map;
    chatRoomId = argument['chatRoomId'];
    friendUserId = argument['friendUserId'];
    friendNickname = argument['friendNickname'];
    userId = argument['userId'];
    chatRoomName = argument['chatRoomName'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.grey[100],
          title: Text(
            chatRoomName,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleAppBarMenuClick,
              itemBuilder: (BuildContext context) {
                return {'채팅방 정보 보기', '채팅방 나가기'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      floatingActionButton: DoneCountFAB(
          coinCount: coinCount,
          myCoinCount: myCoinCount,
          friendCoinCount: friendCoinCount),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            messageStream,
            SizedBox(
              height: 5.5,
            ),
            MessageSender(
              userId: userId,
              friendUserId: friendUserId,
              chatRoomId: chatRoomId,
              scrollDownCallback: () {
                messageStream.scrollDown();
              },
            ),
          ],
        ),
      ),
    );
  }
}
