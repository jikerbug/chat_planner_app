import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Data extends ChangeNotifier {
  Data({required this.mainRouteContext, required this.userId});
  final BuildContext mainRouteContext;
  final String userId;

  Map userInfo = {};

  void setUserInfo(Map fetchedUserInfo) {
    userInfo = fetchedUserInfo;
  }
}
