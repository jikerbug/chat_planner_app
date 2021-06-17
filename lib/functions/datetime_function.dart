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

  static String todayDateString(selectedDay, nowWhenReloaded) {
    if (selectedDay == '전체') {
      return '전체 요일';
    }
    DateTime selectedDateTime =
        getDateTimeOfSelectedDate(selectedDay, nowWhenReloaded);
    String result;
    result =
        '${selectedDateTime.year}년 ${selectedDateTime.month}월 ${selectedDateTime.day}일 ${dayListForPlanScreen[selectedDateTime.weekday]}요일';
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

  static Future<String> selectDate(habitEndOrTaskDateInfo, context) async {
    if (habitEndOrTaskDateInfo == noLimitNotation) {
      habitEndOrTaskDateInfo = DateTime.now().toString().substring(0, 10);
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
      return picked.toString().substring(0, 10);
    } else {
      return noLimitNotation;
    }
  }
}
