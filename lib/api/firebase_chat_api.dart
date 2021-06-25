import 'package:firebase_database/firebase_database.dart';

class FirebaseChatApi {
  //리스너를 단 놈들은 어차피 따로 fetch가 되기 때문에, userInfo와 따로 구성함

  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final DatabaseReference chatInfoRef =
      database.reference().child("chatInfo");

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
