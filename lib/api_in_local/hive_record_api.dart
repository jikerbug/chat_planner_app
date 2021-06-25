import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/plan_model.dart';
import 'package:chat_planner_app/models_hive/record_model.dart';
import 'package:chat_planner_app/models_hive/todo_record_model.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class HiveRecordApi {
  static final todoBox = Hive.box<TodoRecordModel>(kTodoRecordBoxName);

  static Map getRecordsMapOfPlan(planCreatedTime, isHabit) {
    if (isHabit) {
      final box = Hive.box<RecordModel>(planCreatedTime);
      return box.toMap();
    } else {
      return todoBox.toMap();
    }
  }

  static Future<String> openHabitRecordBox(planCreatedTime, isHabit) async {
    ///앱시작할때와, 원래 없었던 놈 새로 제작할때 얘가 필요하다.
    if (isHabit) {
      if (!Hive.isBoxOpen(planCreatedTime)) {
        await Hive.openBox<RecordModel>(planCreatedTime);
      }
    }
    return 'success';
  }

  static Future<void> addRecord({
    required PlanModel item,
    required doneTimestamp,
  }) async {
    var box;

    if (item.isHabit) {
      box = Hive.box<RecordModel>(item.createdTime);
    } else {
      box = todoBox;
    }

    int id = 0;

    if (box.isNotEmpty) {
      final prevItem = box.getAt(box.length - 1);

      if (prevItem != null) {
        id = prevItem.id + 1;
      }
    }

    var putModel;

    if (item.isHabit) {
      putModel = RecordModel(
        id: id,
        doneTimestamp: doneTimestamp,
      );
    } else {
      putModel = TodoRecordModel(
          id: id,
          doneTimestamp: doneTimestamp,
          planCreatedTime: item.createdTime,
          title: item.title);
    }

    box.put(
      id,
      putModel,
    );
    box.values.forEach((element) {
      print(element.id);
    });
  }

  static void deleteRecordOfToday(
      {required PlanModel item, required String deleteTimestamp}) async {
    var box;

    if (item.isHabit) {
      box = Hive.box<RecordModel>(item.createdTime);
    } else {
      box = todoBox;
    }

    print('before delete');
    box.values.forEach((element) {
      print(element.id);
    });
    if (item.isHabit) {
      box.values
          .where((element) => DateTimeFunction.isSameDate(
              deleteTimestamp, element.doneTimestamp))
          .forEach((element) {
        box.delete(element.id);
      });
    } else {
      box.values
          .where((element) => (DateTimeFunction.isSameDate(
                  deleteTimestamp, element.doneTimestamp) &&
              element.planCreatedTime == item.createdTime))
          .forEach((element) {
        box.delete(element.id);
      });
    }

    print('after delete');
    box.values.forEach((element) {
      print(element.id);
    });
  }
}
