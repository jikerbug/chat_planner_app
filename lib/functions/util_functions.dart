import 'package:intl/intl.dart';

class UtilFunctions {
  static List userCodeAList = [
    '춤추는',
    '유연한',
    '명랑한',
    '매력적인',
    '건강한',
    '활기찬',
    '위대한',
    '집중하는',
    '신뢰받는',
    '귀여운'
  ];

  static List userCodeBList = [
    '회색',
    '갈색',
    '파란',
    '노란',
    '주황',
    '민트색',
    '하늘색',
    '검은',
    '흰색',
    '초록',
  ];

  static List userCodeCList = [
    '물범',
    '얼룩말',
    '사자',
    '치타',
    '재규어',
    '캥거루',
    '공작새',
    '독수리',
    '호랑이',
    '돌고래',
  ];

  static bool isUserMatchedWithFriend(chatRoomId, userId) {
    if (chatRoomId != null &&
        chatRoomId != userId &&
        chatRoomId != 'mainWaitingRoom') {
      return true;
    } else {
      return false;
    }
  }

  static String userEmailToUserId(userEmail) {
    String userId = userEmail.substring(0, userEmail.indexOf('.'));
    return userId;
  }

  static String userIdToWaitingRoomUserNickname(userId) {
    int userCode = userId.hashCode;

    int codeA = userCode % 1000 ~/ 100;
    int codeB = userCode % 1000000 ~/ 100000;
    int codeC = userCode % 1000000000 ~/ 100000000;
    print(codeA);
    print(codeB);
    print(codeC);
    String groupChatId =
        userCodeAList[codeA] + userCodeBList[codeB] + userCodeCList[codeC];
    return groupChatId;
  }

  static int birthdayToAge(birthday) {
    int birthYear = int.parse(birthday.split('-')[0]);
    int thisYear = DateTime.now().year;
    int age = thisYear - birthYear + 1;
    return age;
  }

  static DateTime getExpireTime(DateTime startTime) {
    DateTime expiredTime = startTime.add(Duration(days: 3)); //3일의 기간!!
    String expiredDay = DateFormat('yyyy-MM-dd').format(expiredTime);
    print(
        "계산된 expredTime : ${DateTime.parse(expiredDay).add(Duration(hours: 12))}");
    return DateTime.parse(expiredDay).add(Duration(hours: 12));
    //UTC + 9시이기 때문에 +9+3으로 해야 12시가 된다...? no! 어차피 time은 기기가 위치한 지역에 따라 달라진다.
    //기기설정 서울로 해놓으면 된다...? 이것도 안먹히는듯
    //어쨌든 내 갤럭시 폰에서는 12시로 잘 나왔다.
  }
}
