import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_planner_app/api/firestore_send_prebuilt_msg_api.dart';
import 'package:chat_planner_app/functions/util_functions.dart';
import 'package:intl/intl.dart';

import 'firebase_chat_api.dart';

class FireStoreApi {
  static final _fireStore = FirebaseFirestore.instance;

  static Future<void> createChatRoomWhenFirstRegistered(userId) async {
    //가입시, defaultUserInfo에서 isChatRoomStateChanged를 true로 설정했기 때문에 여기에서 뭔가 할 것은 없다.
    DateTime sendDate = DateTime.now();
    String sendDateFormatted = DateFormat('yyyy-MM-dd').format(sendDate);

    await _fireStore.collection('chatRooms').doc(userId).set({
      'lastSentDate': sendDateFormatted,
      'isDeletedAccount': false,
      //1주일마다 주기적으로 탈퇴회원 갠톡 삭제를 진행할 것이다
      //이때 'isDeletedAccount'가 true인 chatRoom을 삭제할 것이다.
    });

    FireStoreSendPrebuiltMsgApi.createChatRoomWhenFirstRegistered(
        userId, sendDate, sendDateFormatted);
  }

  static Future<void> sendDateBubbleIfLastSentDateIsNotToday(
      String chatRoomId) async {
    DateTime sendDate = DateTime.now();
    String sendDateFormatted = DateFormat('yyyy-MM-dd').format(sendDate);

    DocumentSnapshot ds =
        await _fireStore.collection('chatRooms').doc(chatRoomId).get();

    Map data = ds.data() as Map;
    String lastSentDate = data['lastSentDate'];
    if (lastSentDate != sendDateFormatted) {
      await _fireStore
          .collection('chatRooms')
          .doc(chatRoomId)
          .update({"lastSentDate": sendDateFormatted});
      await _fireStore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({'time': sendDate, 'type': 'date', 'date': sendDateFormatted});
    }
  }

  static Future<Map> createChatRoomDocAndGetInfo(now, userId, friendId) async {
    String sendDateFormatted = DateFormat('yyyy-MM-dd').format(now);
    DateTime expireTime = UtilFunctions.getExpireTime(now);

    DocumentReference dr = await _fireStore.collection('chatRooms').add({
      "createdTime": now,
      "expireTime": expireTime,
      "extendCount": 0,
      "lastSentDate": sendDateFormatted,
      "createUser": userId,
      "habitGroup": 'study',
      "userCount": 2,
      "mostHighAchievement": 1,
      "isAutoExitActivated": true,
      "isHabitReminderActivated": true,
      "lastDoneTime": DateTime.now(),
      //"lastSentDate는 sendDateBubbleIfLastSentDateIsNotToday함수에서 set해준다"
    });
    await _fireStore
        .collection('chatRooms')
        .doc(dr.id)
        .collection('chatRoomInfo')
        .doc('LastDoneInfo')
        .set({
      "userProfileList": {userId: 'none', userId: 'none'},
      "userList": [userId, friendId],
      userId + 'LDD': DateTime.now(),
      friendId + 'LDD': DateTime.now(),
      userId + 'LDH': DateTime.now(),
      friendId + 'LDH': DateTime.now(),
      //"lastSentDate는 sendDateBubbleIfLastSentDateIsNotToday함수에서 set해준다"
    });
    return {
      'chatRoomId': dr.id,
      'sendDateFormatted': sendDateFormatted,
      'expireTime': expireTime,
    };
  }

  static void sendExitChatRoomMessageToEachOther(
      userId, friendUserId, isCausedByExpire) async {
    String exitChatRoomMsg;
    if (isCausedByExpire) {
      exitChatRoomMsg = '실천친구와의 채팅방이 만료되었습니다.';
    } else {
      exitChatRoomMsg = '실천친구가 채팅방을 떠났습니다.';
    }
    await sendDateBubbleIfLastSentDateIsNotToday(friendUserId);
    FireStoreSendPrebuiltMsgApi.exitChatRoom(friendUserId, exitChatRoomMsg);

    if (!isCausedByExpire) {
      exitChatRoomMsg = '실천친구와의 채팅방을 떠났습니다.';
    }
    await sendDateBubbleIfLastSentDateIsNotToday(userId);
    FireStoreSendPrebuiltMsgApi.exitChatRoom(userId, exitChatRoomMsg);
  }

  //// 메세지 관련 ---------------------------------------------------------------////

  static Query getMessagesQuery(chatRoomId) {
    DateTime limitDateTime = DateTime.now().subtract(Duration(days: 3));
    String expiredDay = DateFormat('yyyy-MM-dd').format(limitDateTime);
    limitDateTime = DateTime.parse(expiredDay);

    Timestamp limitTime = Timestamp.fromDate(limitDateTime);

    return _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .endAt([limitTime]);

    ///sendMessageDateBubble을 보낼때, OneDaysAgoTimeStamp를 체크, 갱신 (대기단체챗)
    ///sendMessageDateBubble을 보낼때, ThreeDaysAgoTimeStamp를 : 해당을 Timestamp로!!
  }

  static void sendMessage(text, userId, chatRoomId, friendUserId, time,
      {isFirstTimeline = true}) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, friendUserId);

    //await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    //얘는 firstTimeLine 체크를 위해 밖에서 메세지를 보낸다. 따라서 밖에서 해당 프로세스를 진행할 것이다.
    _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': text,
      'sender': userId,
      'time': time,
      'type': 'chat',
      'isFirstTimeline': isFirstTimeline,
    });
  }

  static void sendAddAgainMessages(
      title, userId, chatRoomId, checkCount, friendUserId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, friendUserId);
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    String userMsg = '$title 한번 더 실천해볼게\n(현재까지 총 $checkCount회 실천)';
    messagesCollection.add({
      'text': userMsg,
      'sender': userId,
      'time': DateTime.now(),
      'type': 'add'
    });
  }

  static void sendAddMessages(
      title, selectedCategory, userId, chatRoomId, friendUserId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, friendUserId);
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    String userMsg = '$title $selectedCategory해볼게';
    messagesCollection.add({
      'text': userMsg,
      'sender': userId,
      'time': DateTime.now(),
      'type': 'add'
    });
  }

  static void sendDoneMessages(title, userId, chatRoomId, friendUserId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, friendUserId);
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    String userMsg = '$title 완료!';

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection.add({
      'text': userMsg,
      'sender': userId,
      'time': DateTime.now().toLocal(),
      'type': 'done'
    });
  }

  static void sendTimerMessages(
      title, userId, chatRoomId, minuteCount, friendUserId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, friendUserId);
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    String userMsg = '$title 실천하기\n$minuteCount분 완료!';

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection.add({
      'text': userMsg,
      'sender': userId,
      'time': DateTime.now().toLocal(),
      'type': 'done'
    });
  }

  static void sendHeartGiftMessage(userId, chatRoomId, friendUserId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, friendUserId);
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection.add({
      'text': '하트 1개를 선물했습니다.',
      'sender': userId,
      'time': DateTime.now().toLocal(),
      'type': 'gift'
    });
  }

  //--------------------------------getter ----------------------------//

  static Future<Map> getChatRoomInfo(chatRoomId) async {
    DocumentSnapshot ds =
        await _fireStore.collection('chatRooms').doc(chatRoomId).get();
    return ds.data() as Map;
  }
}