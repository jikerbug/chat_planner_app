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
      'category': category,
      "password": password,
      'totalDoneCount': 0, //리스너
      'thisWeek': now, //리스너
      "createdTime": now,
      'weeklyDoneCount': 0,
      "maxMemberNum": maxMemberNum,
      "memberList": [User().userId],
      "isFull": false,
      "lastSentDate": sendDateFormatted,
      //이거 어차피 lastSentTime으로 대체가능? 하지만 어차피 여기있는 정보들 다 채팅방입장할때 불러오니까 그냥 이걸로 쓰자?
      //TODO:아니다. 애초에, message에 있는 마지막 sentTime이, 지금 보내려는 시간이랑 다르면 dateBubble을 보내면 되잖아?...
      //아래의 3가지 빼고는 전부 채팅방 입장시 항상 활용하는 것들이다
      //사실 chatRoomTitle빼고 다네,,,, 그냥 합치는게 좋겠다
      "chatRoomTitle": chatRoomTitle,
      "description": description,
      "createUser": User().nickname,
    });

    return dr.id;
  }

  static Future<void> createChatRoomWhenFirstRegistered(userId) async {
    //가입시, defaultUserInfo에서 isChatRoomStateChanged를 true로 설정했기 때문에 여기에서 뭔가 할 것은 없다.
    DateTime sendDate = DateTime.now();
    String sendDateFormatted = DateFormat('yyyy-MM-dd').format(sendDate);

    await _fireStore.collection('selfChatRooms').doc(userId).set({
      'lastSentDate': sendDateFormatted,
      'isDeletedAccount': false,
      //1주일마다 주기적으로 탈퇴회원 갠톡 삭제를 진행할 것이다
      //이때 'isDeletedAccount'가 true인 chatRoom을 삭제할 것이다.
    });

    FireStoreSendPrebuiltMsgApi.createChatRoomWhenFirstRegistered(
        userId, sendDate, sendDateFormatted);
  }

  static Future<Map> getChatRoomDetailInfoMap(String chatRoomId) async {
    DocumentSnapshot ds =
        await _fireStore.collection('chatRooms').doc(chatRoomId).get();
    return ds.data() as Map;
  }

  static Query getChatRoomsQuery(String category, String criteria,
      {noFull = false, noPassword = false}) {
    ///주의!!! 사용하는 핗드요소조합만으로 구성된 각각의 색인이 필요하다!!!
    ///사용하는 조합 순서까지도 똑같아야한다!!!!
    Query chatRoomsQuery;
    if (category == '전체') {
      chatRoomsQuery = _fireStore.collection('chatRooms');
    } else {
      chatRoomsQuery = _fireStore
          .collection('chatRooms')
          .where('category', isEqualTo: category);
    }
    // if (noFull) {
    //   chatRoomsQuery = chatRoomsQuery.where('isFull', isEqualTo: false);
    // }
    // if (noPassword) {
    //   chatRoomsQuery = chatRoomsQuery.where('password', isEqualTo: '');
    // }
    return chatRoomsQuery.orderBy(criteria, descending: true);
  }

  static Future<void> sendDateBubbleIfLastSentDateIsNotTodayAndLastSentUpdate(
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
    await sendDateBubbleIfLastSentDateIsNotTodayAndLastSentUpdate(friendUserId);
    FireStoreSendPrebuiltMsgApi.exitChatRoom(friendUserId, exitChatRoomMsg);

    if (!isCausedByExpire) {
      exitChatRoomMsg = '실천친구와의 채팅방을 떠났습니다.';
    }
    await sendDateBubbleIfLastSentDateIsNotTodayAndLastSentUpdate(userId);
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
    FirebaseChatApi.updateLastSentInfoAndMsgCount(
        chatRoomId: chatRoomId, now: time, lastMessage: text);

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

  static void sendAddMessages(title, userId, chatRoomId) async {
    DateTime now = DateTime.now();
    String userMsg = '$title 실천 해볼게';

    FirebaseChatApi.updateLastSentInfoAndMsgCount(
        chatRoomId: chatRoomId, now: now, lastMessage: userMsg);

    await sendDateBubbleIfLastSentDateIsNotTodayAndLastSentUpdate(chatRoomId);
    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection
        .add({'text': userMsg, 'sender': userId, 'time': now, 'type': 'add'});
  }

  static void sendDoneMessages(title, userId, chatRoomId) async {
    await sendDateBubbleIfLastSentDateIsNotTodayAndLastSentUpdate(chatRoomId);

    DateTime now = DateTime.now();
    String userMsg = '$title 완료!';

    FirebaseChatApi.updateLastSentInfoAndMsgCount(
        chatRoomId: chatRoomId, now: now, lastMessage: userMsg);
    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection
        .add({'text': userMsg, 'sender': userId, 'time': now, 'type': 'done'});
  }

  static void sendTimerMessages(title, userId, chatRoomId, minuteCount) async {
    await sendDateBubbleIfLastSentDateIsNotTodayAndLastSentUpdate(chatRoomId);
    String userMsg = '$title 실천하기\n$minuteCount분 완료!';

    DateTime now = DateTime.now();
    FirebaseChatApi.updateLastSentInfoAndMsgCount(
        chatRoomId: chatRoomId, now: now, lastMessage: userMsg);

    final messagesCollection = _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages');

    messagesCollection
        .add({'text': userMsg, 'sender': userId, 'time': now, 'type': 'done'});
  }

  //--------------------------------getter ----------------------------//

  static Future<Map> getChatRoomInfo(chatRoomId) async {
    DocumentSnapshot ds =
        await _fireStore.collection('chatRooms').doc(chatRoomId).get();
    return ds.data() as Map;
  }
}
