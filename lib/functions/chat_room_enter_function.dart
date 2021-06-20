import 'package:flutter/material.dart';
import 'package:chat_planner_app/functions/util_functions.dart';

import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';
import '../api/firestore_api.dart';

class ChatRoomEnterFunctions {
  static void chatRoomEnterProcess(context) async {
    Data providerData = Provider.of<Data>(context, listen: false);
    final mainRouteContext = providerData.mainRouteContext;
    final userId = providerData.userId;
    final chatRoomId = userId;
    final friendUserId = userId;
    final friendNickname = '지백';

    //expire일 경우 어차피 chatAlone으로 입장하기 때문에 위에서 불러온 chatRoomId와 friendUserId가 바뀐것을 반영할 필요 없다.

    pushNamedToChatScreen(
      mainRouteContext,
      '2022-11-11',
      friendUserId,
      chatRoomId,
      userId,
      friendNickname,
      0,
    );
  }

  static void pushNamedToChatScreen(mainRouteContext, expireTime, friendUserId,
      chatRoomId, userId, friendNickname, extendCount) {
    String expireTimeFormatted = expireTime.toString().split(' ')[0];
    Navigator.pushNamed(mainRouteContext, ChatScreen.id, arguments: {
      "friendUserId": friendUserId,
      "chatRoomId": chatRoomId,
      "userId": userId,
      "friendNickname": friendNickname,
      'extendCount': extendCount,
      'expireTimeFormatted': expireTimeFormatted
    });
  }
}
