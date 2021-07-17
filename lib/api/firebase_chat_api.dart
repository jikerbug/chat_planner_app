import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:firebase_database/firebase_database.dart';

import 'firestore_api.dart';

class FirebaseChatApi {
  //리스너를 단 놈들은 어차피 따로 fetch가 되기 때문에, userInfo와 따로 구성함

  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final DatabaseReference chatSearchInfoRef =
      database.reference().child("chatSearchInfo");

  static final DatabaseReference chatMessageInfoRef =
      database.reference().child("chatListInfo");

  static void updateLastSentInfoAndMsgCount(
      {chatRoomId, now, lastMessage, type = ''}) async {
    final totalMessageCount = (await chatMessageInfoRef
            .child(chatRoomId)
            .child('totalMessageCount')
            .once())
        .value;

    chatMessageInfoRef.child(chatRoomId).child('messageInfo').update({
      'lastSentTime': now.toString(),
      'lastMessage': lastMessage,
      'totalMessageCount': totalMessageCount + 1, //for badge
    });

    ///TODO:선택의 기로 : 오늘 다같이 실천한 개수를 표시하고 많은 사용량/등록한 습관 개수를 보여주고 적은 사용량
    ///일단, 습관개수를 보여주는개 좀더 좋은 정보라는 생각이 들었다
    ///그리고 대신에 내가 안읽은 실천수를 볼 수 있게 해주는 것,,,!!
    ///아니면, done의 경우에는 push message를 보여줄 수도,,,,,
    ///어차피 채팅방 입장하면 오늘 몇번실천했는지가 보일것!!!
    ///이렇게 바꾸는게 낫겠다
    // if (type == 'done') {
    //   final totalMessageCount = (await chatMessageInfoRef
    //       .child(chatRoomId)
    //       .child('totalMessageCount')
    //       .once())
    //       .value;
    // }
  }

  static void createChatRoomInfo(chatRoomId, now, category) {
    String nowString = now.toString();
    //어차피 today랑 다르면 todayDoneCount를 0으로 초기화시켜줘야한다
    chatMessageInfoRef.child(chatRoomId).child('messageInfo').set({
      'lastSentTime': nowString,
      'lastMessage': '',
      'todayDoneCount': 0, //리스너 필요
      //todayDoneCount 있으니까, 굳이 뱃지로 또 새로운 Done을 보여줄 필요는 없다고 보여짐 (한번에 3개의 정보는 너무함. 하루에 몇개 했는지만 보여줘도 충분)
      'today':
          nowString, //그냥 자정되면 리셋되는게맞다... 어차피 주간정보도 있으니 //리스너 달아서 오늘날짜랑 다르면 업데이트하고 리셋//로컬에서는 또 따로 리셋
      'totalMessageCount': 0, //for badge
      'currentMemberNum': 1,
    });

    ///아래의 생각정리를 통해, 위의 내용은 변함없이 유지하기로 함
    //위의 4가지가, 채팅방 업데이트에 필요한 정보
    //이중 todayDoneCount는 검색을 위한 조건,,,,?
    //아! today 대신에 weekly로 좀더 의미있는 정보를 만들자
    //어차피 하나 업데이트하나 두개나 세게나 비슷비슷
    //이러면 여기 있는 것은 유저가 불러올 정보
    //결론 : 만약에 위의 것에서 last...만 남기고 firestore로 이전한다면
    //채팅방 리스트 불러올때마다 두곳에서 불러와야한다.
    //너무나 비효율적이다
    //채팅방리스트 불러올때 한번에 이놈들로만으로도 업데이트된 정보를 다 가져올 수 있다
    //여기서 문제는, 동시에 카운트가 증가하는 경우가 발생할 수 있다는 것인데,,,
    //그것은 사실 칭찬할때도 마찬가지 아닌가?
    //그렇다고 칭찬을 현재로서 firestore에 옮길수는 없으니,,,
    //하트는, 쓸일이 더 많은 애이긴하다. 적어도 읽는 것과 쓰는게 비슷,,,
    //읽는데 쓰는것보다 훨씬 많을때 firestore를 쓴다
    //계속 쌓이는 데이터일때 firestore를 쓴다
    //20000번 쓸때 무료,,,
    //10만번 쓸때
    //치명적이지 않은 약간의 버그는 허용하도록 하자

    ///아래의 생각정리를 통해, 위의 내용은 추후에 firestore로 통합될 수도 있음
    //위의 6가지는 검색 정렬을 위한 조건
    //동시에, 채팅방 입장시 필요한 조건 (totalDoneCount, weeklyDoneCount) but! 클릭할때 각각에 리스너 달아주면 되니까 엄밀히 말하면 필요없다
    //즉, 위의 6가지는 firestore에 있는 것들과 합쳐져도 된다...? NO! => 필요한 것은 count뿐이니 그것에 대해서만 리스너,,,, 못단다...!!!!
    //즉 어차피 firestore로 위의 두 그룹이 옮겨져도 분리되어있는게 더 효율적이다...? No => 사실 읽은 횟수로 치기 때문에 그냥 합치는게 더 좋다
    //그냥 얘네만 firestore의 정보란으로 옮기는 것도 방법
    //그런데 여기서,,,!! 채팅방의 카테고리가 변경불가능해진다. 업데이트를 위해서는 plan쪽에서 chatRoom의 category를 알아야한다...
    //하지만 얘네들은 확실히, 쓰는 경우가 더 많다,,,, 일단 그대로 가자
  }

  static Future<List> getChatInfoList(category, criteria) async {
    List<Map> chatInfoList = [];

    final rankHashMap = (await chatSearchInfoRef
            .child(category)
            .orderByChild(criteria)
            .limitToLast(2)
            .once())
        .value;

    if (rankHashMap == null) {
      return [];
    }

    final convertedMap = Map<String, dynamic>.from(rankHashMap);
    // print(convertedMap);

    List<String> chatRoomIdList = [];
    List<Map> chatRoomIdRankInfoList = [];
    convertedMap.forEach((key, value) async {
      chatRoomIdList.add(key);
      chatRoomIdRankInfoList.add(value);
    });

    for (int i = 0; i < chatRoomIdList.length; i++) {
      Map chatRoomDetailInfoMap =
          await FireStoreApi.getChatRoomDetailInfoMap(chatRoomIdList[i]);
      print(chatRoomDetailInfoMap);

      chatRoomIdRankInfoList[i].addAll(chatRoomDetailInfoMap);
      chatRoomIdRankInfoList[i].addAll({
        'chatRoomId': chatRoomIdList[i],
      });
      chatInfoList.add(chatRoomIdRankInfoList[i]);
    }

    print(chatInfoList);
    return chatInfoList;
  }

  static void createChatRoomUserInfo(chatRoomId, userId) {
    //       "lastDoneTime":
    // null, //"lastSentDate는 sendDateBubbleIfLastSentDateIsNotToday함수에서 set해준다"
    // "lastDoneMessage": null,
    ///위의 것 + 각 사람마다의 데이터가 필요...!? ,,, not MVP 일수 있다,,,
    ///자동 강제 퇴장은 not MVP이다.
    ///MVP는 응원감사 + 플래너 + 채팅이다.
  }

  static void chatRoomIdAndFriendInfoListener(userId, context) {}

  static void isChatRoomStateChangedListener(userId, callback) {}

  static void createChatRoomProcess(
      userId, friendUserId, context, userNickname, friendNickname) async {}

  static void exitChatRoomWithFriend(userId, chatRoomId, friendUserId,
      {isCausedByExpire = false, isExitButtonPressedInChatScreen = false}) {}

  static void setDefaultChatInfo(userId) {}

  static void chatRoomStateChangeIdentified(userId) {}

  static Map combinedInfoToChatInfoMap(String combinedInfo) {
    List infoList = combinedInfo.split('-|-');
    if (infoList.length == 3) {
      return {
        'chatRoomId': infoList[0],
        'friendUserId': infoList[1],
        'friendNickname': infoList[2]
      };
    } else {
      return {'chatRoomId': infoList[0]};
    }
  }

  static void setIsExtendVoted(userId, value) {}

  static void setCombinedInfo({userId, combinedInfo}) {}
}
