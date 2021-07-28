import 'package:chat_planner_app/api/firebase_chat_api.dart';
import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/api_in_local/hive_chat_api.dart';
import 'package:chat_planner_app/constants.dart';
import 'package:chat_planner_app/screens/chat/end_drawer.dart';
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
  late List<dynamic> memberList;
  late Map chatRoomInfoFromServer;
  var messageStream = MessageStream('', '', '', '', '');
  var endDrawer = EndDrawer(
    chatRoomId: '',
    memberList: [],
  );

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

      chatRoomInfoFromServer = await FireStoreApi.getChatRoomInfo(chatRoomId);
      memberList = chatRoomInfoFromServer['memberList'];
      endDrawer = EndDrawer(
        chatRoomId: chatRoomId,
        memberList: memberList,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    //어차피 변경은 mainRouteScreen으로 돌아올때 일어난다 -> 입장할때 미리 바꿔줄 필요 x
    FirebaseChatApi.chatRoomStateChangeIdentified(userId);
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      endDrawer: endDrawer,
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.grey[100],
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
          title: Text(
            chatRoomName,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            GestureDetector(
              child: Icon(Icons.menu),
              onTap: () {
                _openEndDrawer();
              },
            ),
            SizedBox(
              width: kAppbarRightMargin(context),
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
