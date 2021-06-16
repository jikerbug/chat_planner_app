class Day {
  Day({this.isSelected = false, required this.name});
  String name;
  bool isSelected;

  click() {
    isSelected = !isSelected;
  }
}

class DateTimeFunction {
  static const String noLimitNotation = '기한 없음';

  static List<String> get dayListForPlanScreen =>
      ['전체', '월', '화', '수', '목', '금', '토', '일'];
  static List<Day> get dayListForPlanAddScreen {
    return [
      Day(name: '월'),
      Day(name: '화'),
      Day(name: '수'),
      Day(name: '목'),
      Day(name: '금'),
      Day(name: '토'),
      Day(name: '일')
    ];
  }

  static String getTodayOfWeek() {
    //weekday는 1부터 7까지, 월요일부터, 일요일까지임!! -> 전체는 index 0이니까 포함될 일 없다.
    return dayListForPlanScreen[DateTime.now().weekday];
  }

  static DateTime getDateTimeOfSelectedDate(String selectedDay) {
    if (selectedDay == '전체') {
      print('이경우는 로직상 도달할 수 없는 것으로 설계됨. \n해당 메시지 발견시 로직 보완바람');
    }
    if (selectedDay == getTodayOfWeek()) {
      return DateTime.now();
    } else {
      DateTime tempDayOfWeekDateTime = DateTime.now();
      bool isSelectedDateFuture = true;
      while (
          dayListForPlanScreen[tempDayOfWeekDateTime.weekday] != selectedDay) {
        if (tempDayOfWeekDateTime.weekday == 1) {
          isSelectedDateFuture = false;
        }
        tempDayOfWeekDateTime = tempDayOfWeekDateTime.add(Duration(days: 1));
      }

      if (selectedDay == dayListForPlanScreen[1]) {
        //월요일
        isSelectedDateFuture = false;
      }

      if (isSelectedDateFuture) {
        return tempDayOfWeekDateTime;
      } else {
        return tempDayOfWeekDateTime.subtract(Duration(days: 7));
      }
    }
  }
}
