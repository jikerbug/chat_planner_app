import 'package:flutter/material.dart';

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

  static String getTodayOfWeek(DateTime nowSyncedAtReload) {
    //weekday는 1부터 7까지, 월요일부터, 일요일까지임!! -> 전체는 index 0이니까 포함될 일 없다.
    return dayListForPlanScreen[nowSyncedAtReload.weekday];
  }

  static DateTime getDateTimeOfSelectedDate(
      String selectedDay, DateTime nowSyncedAtReload) {
    if (selectedDay == '전체') {
      print('이경우는 로직상 도달할 수 없는 것으로 설계됨. \n해당 메시지 발견시 로직 보완바람');
    }
    if (selectedDay == getTodayOfWeek(nowSyncedAtReload)) {
      return nowSyncedAtReload;
    } else {
      DateTime tempDayOfWeekDateTime = nowSyncedAtReload;
      bool isSelectedDateFuture = true;
      while (
          dayListForPlanScreen[tempDayOfWeekDateTime.weekday] != selectedDay) {
        if (tempDayOfWeekDateTime.weekday == 1) {
          //월요일(월요일을 거쳐서 한주가 바뀌어야 선택한 요일로 돌아올 수 있음)
          isSelectedDateFuture = false;
        }
        tempDayOfWeekDateTime = tempDayOfWeekDateTime.add(Duration(days: 1));
      }

      if (selectedDay == dayListForPlanScreen[1]) {
        //월요일은 애초에 현재아니면 과거
        isSelectedDateFuture = false;
      }

      if (isSelectedDateFuture) {
        return tempDayOfWeekDateTime;
      } else {
        return tempDayOfWeekDateTime.subtract(Duration(days: 7));
      }
    }
  }

  static String doneDateTimeString(String doneTimestamp) {
    DateTime doneDateTime = DateTime.parse(doneTimestamp);
    String doneInfo =
        '${doneDateTime.month}월 ${doneDateTime.day}일 ${dayListForPlanScreen[doneDateTime.weekday]}요일';
    doneInfo += ' ';
    doneInfo += '${doneDateTime.hour}시 ${doneDateTime.minute}분';
    return doneInfo;
  }

  static String wholeDayOfWeekInfo = '전체 요일(금일 실천)';
  static String todayDateString(selectedDay, nowWhenReloaded) {
    if (selectedDay == '전체') {
      return wholeDayOfWeekInfo;
    }
    DateTime selectedDateTime =
        getDateTimeOfSelectedDate(selectedDay, nowWhenReloaded);
    String result;
    result =
        '${selectedDateTime.month}월 ${selectedDateTime.day}일 ${dayListForPlanScreen[selectedDateTime.weekday]}요일';
    if (selectedDay == dayListForPlanScreen[nowWhenReloaded.weekday]) {
      result += '(금일)';
    }
    return result;
  }

  static bool isSameDate(String a, String b) {
    DateTime adt = DateTime.parse(a);
    DateTime bdt = DateTime.parse(b);
    return adt.year == bdt.year && adt.month == bdt.month && adt.day == bdt.day;
  }

  static String dateTimeToDateString(selectedDateTime) {
    return selectedDateTime.toString().substring(0, 10);
  }

  static Future<String> selectDate(habitEndOrTaskDateInfo, context) async {
    if (habitEndOrTaskDateInfo == noLimitNotation) {
      habitEndOrTaskDateInfo = dateTimeToDateString(DateTime.now());
    }
    // locale 설정하기 위해 pubspec_copy.yaml 파일과 메인에 코드 추가!!
    DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KO'),
      initialDate: DateTime.parse(habitEndOrTaskDateInfo),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (BuildContext context, Widget? child) {
        return Theme(
            data: ThemeData(
              primaryColor: Colors.teal,
              primarySwatch: Colors.teal,
            ),
            child: child!);
      },
    );
    if (picked != null) {
      return dateTimeToDateString(picked);
    } else {
      return noLimitNotation;
    }
  }
}
