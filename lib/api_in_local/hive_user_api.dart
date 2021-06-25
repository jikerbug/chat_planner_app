import 'package:chat_planner_app/api_in_local/hive_plan_api.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/user_model.dart';
import 'package:hive/hive.dart';

class HiveUserApi {
  static final _box = Hive.box<UserModel>('user');
  static void refreshPlanByLastCheckInDate(userId, nowSyncedAtReload, planBox) {
    if (_box.values.isEmpty) {
      HiveUserApi.addUser(box: _box, userId: userId);
      print('addUserFirst');
    } else {
      _box.values
          .where((element) => (element.userId == userId))
          .forEach((element) {
        if (!DateTimeFunction.isSameDate(
            nowSyncedAtReload.toString(), element.lastCheckInDate)) {
          _box.put(
            element.id,
            UserModel(
              id: element.id,
              userId: userId,
              lastCheckInDate: DateTime.now().toString(),
            ),
          );
          HivePlanApi.unCheckEveryPlan(planBox);
          print('uncheck!!');
        }
      });
    }
  }

  static void addUser({
    required box,
    required userId,
  }) {
    int id = 0;

    if (box.isNotEmpty) {
      final prevItem = box.getAt(box.length - 1);

      if (prevItem != null) {
        id = prevItem.id + 1;
      }
    }

    box.put(
      id,
      UserModel(
        id: id,
        userId: userId,
        lastCheckInDate: DateTime.now().toString(),
      ),
    );
  }
}
