import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSendPrebuiltMsgApi {
  static final _fireStore = FirebaseFirestore.instance;

  static void createChatRoomWhenFirstRegistered(
      userId, sendDate, sendDateFormatted) async {
    await _fireStore
        .collection('chatRooms')
        .doc(userId)
        .collection('messages')
        .add({
      'time': sendDate,
      'type': 'date',
      'date': sendDateFormatted,
    });

    List<String> msgList = [
      '챗플래너에 오신 것을 환영합니다!',
      '저는 앞으로 여러분과 함께할 실천요정입니다~',
      '챗플래너는 실천친구와 함께 실천하며 소중한 하루하루를 더 보람차게 보내기 위해 만들어졌습니다.',
      '실천친구를 찾아 함께 실천해보세요~'
    ];

    bool isFirstTimeline = true;
    for (String msg in msgList) {
      await Future.delayed(const Duration(seconds: 1), () async {
        _fireStore
            .collection('chatRooms')
            .doc(userId)
            .collection('messages')
            .add({
          'text': msg,
          'sender': '실천요정',
          'time': DateTime.now(),
          'type': 'guide',
          'isFirstTimeline': isFirstTimeline
        });
        isFirstTimeline = false;
      });
    }
  }

  static void createChatRoom(
      chatRoomId, sendDateFormatted, expireTime, userId, now) async {
    //바텀바 빨간점으로, 생성된것 표시(상대방에게)
    //상대방의 chatRoomInfo set해줄때 chatRoomStateChange 작업 해준다.

    await _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'time': now,
      'type': 'date',
      'date': sendDateFormatted,
    });

    //expireTime : 2021-04-14 12:00:00.000형태임!
    String expireTimeFormatted = expireTime.toString().split(' ')[0];
    int goalCount = 100;

    List<String> msgList = [
      '실천채팅이 시작되었습니다!',
      '채팅방이 유지되는 동안은 자신이 적립한 코인이 실천친구에게도 적립됩니다',
      '마찬가지로, 실천친구가 적립한 코인이 자신에게도 적립됩니다.',
      '채팅방은 3일뒤인 $expireTimeFormatted 낮 12시에 만료됩니다.',
      '만료시각 전까지 서로가 채팅연장을 신청했을 경우 3일이 연장됩니다.',
      '단, 이때 함께 적립한 총 코인 개수가 $goalCount개 이상이어야 연장이 완료됩니다.',
      '채팅방 좌측 상단에는 만료시각 전까지 함께 적립한 총 코인개수가 나타납니다.',
      '앞으로 열심히 실천해봅시다~'
    ];

    bool isFirstTimeline = true;
    int secondCount = 0;
    for (String msg in msgList) {
      print(msg);
      await Future.delayed(Duration(seconds: secondCount), () async {
        _fireStore
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .add({
          'text': msg,
          'sender': '실천요정',
          'time': DateTime.now(),
          'type': 'guide',
          'isFirstTimeline': isFirstTimeline
        });
      });
      if (secondCount < 5) {
        secondCount++;
      }
      isFirstTimeline = false;
    }
  }

  static void expireTimeIncrement(
      chatRoomId, newExtendCount, expireTimeFormatted) async {
    int goalCoinCount = (newExtendCount + 1) * 100;

    List<String> msgList = [
      '채팅이 연장되었습니다. 3일 뒤인 $expireTimeFormatted 낮 12시에 채팅이 만료됩니다.',
      '만료시각 전까지 서로가 채팅연장을 신청했을 경우 3일이 연장됩니다.',
      '단, 이때 함께 적립한 총 코인 개수가 $goalCoinCount개 이상이어야 연장에 성공합니다.',
      '앞으로 열심히 실천해봅시다~',
    ];

    bool isFirstTimeline = true;
    int secondCount = 0;
    for (String msg in msgList) {
      print(msg);
      await Future.delayed(Duration(seconds: secondCount), () async {
        _fireStore
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .add({
          'text': msg,
          'sender': '실천요정',
          'time': DateTime.now(),
          'type': 'guide',
          'isFirstTimeline': isFirstTimeline
        });
      });
      if (secondCount < 4) {
        secondCount += 2;
      }
      isFirstTimeline = false;
    }
  }

  static void exitChatRoom(chatRoomIdWhichIsUserId, exitChatRoomMsg) async {
    String chatRoomId = chatRoomIdWhichIsUserId;

    _fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': exitChatRoomMsg,
      'sender': '실천요정',
      'time': DateTime.now(),
      'type': 'guide',
      'isFirstTimeline': true,
    });
  }
}
