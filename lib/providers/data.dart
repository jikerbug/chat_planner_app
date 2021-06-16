import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_planner_app/models/plan.dart';

class Data extends ChangeNotifier {
  Data({
    required this.mainRouteContext,
    required this.userId,
  });
  final BuildContext mainRouteContext;
  final String userId;
  List<Plan> planList = [];
  Map userInfo = {};

  void setUserInfo(Map fetchedUserInfo) {
    userInfo = fetchedUserInfo;
  }

  void setTaskList(List<Plan> tasks) {
    planList = tasks;
  }

  void delete(index) {
    planList.removeAt(index);
    notifyListeners();
  }

  void addToList(String title, String timestamp, int checkCount, int index) {
    planList.add(Plan(title: title, timestamp: timestamp, index: index));
    notifyListeners();
  }

  void toggleCheckBox(index) {
    planList[index].toggleCheckBox();
    notifyListeners();
  }

  int get listCount {
    return planList.length;
  }

  String getText(index) {
    return planList[index].title;
  }

  bool getIsChecked(index) {
    return planList[index].isChecked;
  }

  String getTimestamp(index) {
    return planList[index].timestamp;
  }
}
