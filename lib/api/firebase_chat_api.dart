import 'package:firebase_database/firebase_database.dart';

class FirebaseChatApi {
  //리스너를 단 놈들은 어차피 따로 fetch가 되기 때문에, userInfo와 따로 구성함

  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final DatabaseReference chatInfoRef =
      database.reference().child("chatInfo");

  static void createUserStateAboutChatRoomInfo(chatRoomId) {
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

  static void changeChatRoomStateOfFriendIfMatched(
      String chatRoomId, String userId, String friendUserId) {}

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
