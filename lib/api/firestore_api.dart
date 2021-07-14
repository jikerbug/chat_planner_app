import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_planner_app/api/firestore_send_prebuilt_msg_api.dart';
import 'package:chat_planner_app/functions/util_function.dart';
import 'package:intl/intl.dart';

import 'firebase_chat_api.dart';

class FireStoreApi {
  static final _fireStore = FirebaseFirestore.instance;

  static Future<String> createChatRoom(
      chatRoomTitle, category, maxMemberNum, password, description, now) async {
    String sendDateFormatted =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    DocumentReference dr = await _fireStore.collection('chatRooms').add({
      "chatRoomTitle": chatRoomTitle,
      "description": description,
      // "lastSentDate": sendDateFormatted, 이거 어차피 lastSentTime으로 대체가능
      "createUser": User().userId,
      "category": category,
      "password": password,
      "maxMemberNum": maxMemberNum,
    });

    ///주의!!!! lastSentDate는 메시지 버블을 위한 것이다
    ///따라서 lastSentDateTime이 있더라도, 그것은 RTDB에 있을 것이다.
    ///왜냐? 쓰는 횟수가 많은 정보이기 때문이다. 어차피 네트워크에 연결하여 불러올때만 lastSentDateTime이 필요하다.
    ///하지만 이 정보는 채팅방 사용자가 채팅을 입력할때마다 업데이트된다

    return dr.id;
  }

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
    //DateTime limitDateTime = DateTime.now().subtract(Duration(days: 3));
    //String expiredDay = DateFormat('yyyy-MM-dd').format(limitDateTime);
    //limitDateTime = DateTime.parse(expiredDay);

    //Timestamp limitTime = Timestamp.fromDate(limitDateTime);

    return _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true);
    // .endAt([limitTime]);

    ///sendMessageDateBubble을 보낼때, OneDaysAgoTimeStamp를 체크, 갱신 (대기단체챗)
    ///sendMessageDateBubble을 보낼때, ThreeDaysAgoTimeStamp를 : 해당을 Timestamp로!!
  }

  static void sendMessage(text, userId, chatRoomId, time,
      {isFirstTimeline = true}) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, 'friendUserId');

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
      title, userId, chatRoomId, checkCount) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, 'friendUserId');
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
      title, selectedCategory, userId, chatRoomId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, 'friendUserId');
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

  static void sendDoneMessages(title, userId, chatRoomId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, 'friendUserId');
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    String userMsg = '$title 완료!';

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection.add({
      'text': userMsg,
      'sender': userId,
      'time': DateTime.now(),
      'type': 'done'
    });
  }

  static void sendTimerMessages(title, userId, chatRoomId, minuteCount) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, 'friendUserId');
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);
    String userMsg = '$title 실천하기\n$minuteCount분 완료!';

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection.add({
      'text': userMsg,
      'sender': userId,
      'time': DateTime.now(),
      'type': 'done'
    });
  }

  static void sendHeartGiftMessage(userId, chatRoomId) async {
    FirebaseChatApi.changeChatRoomStateOfFriendIfMatched(
        chatRoomId, userId, 'friendUserId');
    await sendDateBubbleIfLastSentDateIsNotToday(chatRoomId);

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection.add({
      'text': '하트 1개를 선물했습니다.',
      'sender': userId,
      'time': DateTime.now(),
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
