import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/screens/plan/plan_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';

class ChatRoomEnterFunctions {
  static void chatRoomEnterProcess(context, chatRoomId, chatRoomTitle,
      {type = 'chatList'}) async {
    BuildContext targetContext = context;
    if (type == 'chatList') {
      Data providerData = Provider.of<Data>(context, listen: false);
      targetContext = providerData.mainRouteContext;
    } else if (type == PlanAddScreen.id) {}

    final userId = User().userId;
    final friendUserId = userId;
    final friendNickname = '지백';

    //expire일 경우 어차피 chatAlone으로 입장하기 때문에 위에서 불러온 chatRoomId와 friendUserId가 바뀐것을 반영할 필요 없다.

    pushNamedToChatScreen(targetContext, '2022-11-11', friendUserId, chatRoomId,
        userId, friendNickname, 0, chatRoomTitle);
  }

  static void pushNamedToChatScreen(mainRouteContext, expireTime, friendUserId,
      chatRoomId, userId, friendNickname, extendCount, chatRoomName) {
    String expireTimeFormatted = expireTime.toString().split(' ')[0];
    Navigator.pushNamed(mainRouteContext, ChatScreen.id, arguments: {
      "friendUserId": friendUserId,
      "chatRoomId": chatRoomId,
      "userId": userId,
      "friendNickname": friendNickname,
      'extendCount': extendCount,
      'expireTimeFormatted': expireTimeFormatted,
      'chatRoomName': chatRoomName
    });
  }
}
