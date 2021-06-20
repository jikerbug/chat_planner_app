import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/functions/util_functions.dart';
import 'package:chat_planner_app/widgets/chat/chat_screen/bubble.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MessageStream extends StatelessWidget {
  MessageStream(
    this.userId,
    this.chatRoomId,
    this.friendNickname,
    this.friendUserId,
    this.friendProfileUrl,
  );

  final String userId;
  final String chatRoomId;
  final String friendNickname;
  final String friendUserId;
  final String friendProfileUrl;

  final ScrollController scrollController = new ScrollController();

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  bool checkIfMsgIsLastTimeline(sendTime, nextSendTime, sender, nextSender) {
    //타임라인 체크
    if (nextSendTime == null) {
      return true;
    } else {
      String sendTimeFormatted =
          DateFormat('yyyy-MM-dd HH:mm').format(sendTime);
      String nextSentTimeFormatted =
          DateFormat('yyyy-MM-dd HH:mm').format(nextSendTime);
      if (sendTimeFormatted != nextSentTimeFormatted) {
        return true;
      } else {
        //보낸사람 체크
        //이때 어차피 nextSender가 null일 경우, 즉 마지막 메세지인 경우
        //어차피 nextSendTime == null에 걸려서 여기로 안온다.
        if (sender != nextSender) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map messageDateMap = {};
    Map messageSenderMap = {};

    if (userId == '') {
      return Container();
    }
    return Expanded(
      child: PaginateFirestore(
        physics: BouncingScrollPhysics(),
        itemsPerPage: 15,
        scrollController: scrollController,
        shrinkWrap: true,
        reverse: true,
        //item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.listView, //Change types accordingly
        itemBuilder: (index, context, documentSnapshot) {
          Map data = documentSnapshot.data() as Map;

          ///주의! 가장 최근의 메세지가 index 0임
          Timestamp timestamp = data['time'];
          DateTime time = timestamp.toDate();

          String noonOrAfternoon;
          int hour = time.hour;
          if (hour > 12) {
            noonOrAfternoon = '오후';
            hour = hour - 12;
          } else {
            noonOrAfternoon = '오전';
          }
          String timeline;
          int minute = time.minute;
          if (minute < 10) {
            timeline = ' $noonOrAfternoon $hour:0${time.minute.toString()} ';
          } else {
            timeline = ' $noonOrAfternoon $hour:${time.minute.toString()} ';
          }

          String messageDate = DateFormat('yyyy-MM-dd').format(time);
          if (data['type'] == 'date') {
            return dateBubble(context, messageDate, time);
          }
          bool isMe = data['sender'] == userId;

          //가장 최근의 메세지부터 나오기 시작한다.
          ///따라서 메세지 옆에 숫자가 표시될지는 바로 앞전에 나온 timeline을 보면 알 수 있다.

          if ((messageDateMap[index] ?? time) != time) {
            messageDateMap = {};
            messageSenderMap = {};
          }
          bool isLastTimeline = checkIfMsgIsLastTimeline(
              time,
              messageDateMap[index - 1] ?? time,
              data['sender'],
              messageSenderMap[index - 1]);

          bool isLastMessage = false;
          if (index == 0) {
            isLastTimeline = true;
            isLastMessage = true;
          }

          bool isFirstTimeline = data['isFirstTimeline'] ?? true;
          //실천요정이랑 채팅이 겹칠경우 대비(사실 3인 이상인 경우는 해당 로직 필수)
          // if (documentSnapshot.data()['sender'] !=
          //     messageSenderMap[index + 1]) {
          //     //[index + 1] 도입시, 새로 문자 보낼때 이상하게 됨,,,,
          //     //-> 그래서 db자체에 isFirstTimeline심어야된거,,,
          //   isFirstTimeline = true;
          // }

          messageDateMap.putIfAbsent(index, () => time);
          messageSenderMap.putIfAbsent(index, () => data['sender']);
          print(index);

          ///index가 두번뜨는 경우 : 불러온 놈이 15아래일때만 발생하는 오류인듯

          String sender = data['sender'];
          if (chatRoomId == 'mainWaitingRoom') {
            sender = UtilFunctions.userIdToWaitingRoomUserNickname(sender);
          } else {
            sender = (friendUserId == sender) ? friendNickname : sender;
          }

          return Bubble(
              text: data['text'],
              sender: sender,
              type: data['type'],
              isMe: isMe,
              time: timeline,
              topLeftRadius: Radius.circular(19.0),
              topRightRadius: Radius.circular(19.0),
              isFirstTimeline: isFirstTimeline,
              isLastTimeline: isLastTimeline,
              isLastMessage: isLastMessage,
              friendProfileUrl: friendProfileUrl);
        },
// orderBy is compulsory to enable pagination
        query: FireStoreApi.getMessagesQuery(chatRoomId),
// to fetch real-time data
        isLive: true,
      ),
    );
  }

  Widget dateBubble(context, messageDate, time) {
    List<String> dateInfoList = messageDate.split('-');

    String year = dateInfoList[0];
    String month = dateInfoList[1];
    String day = dateInfoList[2];
    String dayOfWeek = DateFormat('EEEE').format(time);
    late String dayOfWeekToKorean;

    switch (dayOfWeek) {
      case 'Monday':
        dayOfWeekToKorean = '월요일';
        break;
      case 'Tuesday':
        dayOfWeekToKorean = '화요일';
        break;
      case 'Wednesday':
        dayOfWeekToKorean = '수요일';
        break;
      case 'Thursday':
        dayOfWeekToKorean = '목요일';
        break;
      case 'Friday':
        dayOfWeekToKorean = '금요일';
        break;
      case 'Saturday':
        dayOfWeekToKorean = '토요일';
        break;
      case 'Sunday':
        dayOfWeekToKorean = '일요일';
        break;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15.0, top: 25.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(30.0)),
            width: MediaQuery.of(context).size.width / 2,
            height: 30,
            child: Center(
                child: Text(
              '$year년 $month월 $day일 $dayOfWeekToKorean',
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ],
    );
  }
}
