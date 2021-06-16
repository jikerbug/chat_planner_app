import 'package:intl/intl.dart';

class Day {
  Day({this.isSelected = false, required this.name});
  String name;
  bool isSelected;

  click() {
    isSelected = !isSelected;
  }
}

class DateTimeFunction {
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
    String todayOfWeek = DateFormat('EEEE').format(DateTime.now());
    switch (todayOfWeek) {
      case 'Monday':
        todayOfWeek = '월';
        break;
      case 'Tuesday':
        todayOfWeek = '화';
        break;
      case 'Wednesday':
        todayOfWeek = '수';
        break;
      case 'Thursday':
        todayOfWeek = '목';
        break;
      case 'Friday':
        todayOfWeek = '금';
        break;
      case 'Saturday':
        todayOfWeek = '토';
        break;
      case 'Sunday':
        todayOfWeek = '일';
        break;
    }
    return todayOfWeek;
  }
}
