import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models/plan_model.dart';
import 'package:chat_planner_app/models/record_model.dart';
import 'package:hive/hive.dart';

class HiveRecordApi {
  static final box = Hive.box<RecordModel>('record');

  static Future<void> openPlanRecordBox(planCreatedTime) async {
    if (!Hive.isBoxOpen(planCreatedTime)) {
      await Hive.openBox<RecordModel>(planCreatedTime);
    }
  }

  static void addRecord({
    required PlanModel item,
    required doneTimestamp,
  }) async {
    await openPlanRecordBox(item.createdTime);
    final box = Hive.box<RecordModel>(item.createdTime);
    int id = 0;

    if (box.isNotEmpty) {
      final prevItem = box.getAt(box.length - 1);

      if (prevItem != null) {
        id = prevItem.id + 1;
      }
    }

    box.put(
      id,
      RecordModel(
        id: id,
        doneTimestamp: doneTimestamp,
      ),
    );

    box.values.forEach((element) {
      print(element.id);
    });
  }

  static void deleteRecordOfToday(
      {required PlanModel item, required String deleteTimestamp}) async {
    await openPlanRecordBox(item.createdTime);
    final box = Hive.box<RecordModel>(item.createdTime);
    print('before delete');
    box.values.forEach((element) {
      print(element.id);
    });
    box.values
        .where((element) =>
            DateTimeFunction.isSameDate(deleteTimestamp, element.doneTimestamp))
        .forEach((element) {
      print(element.id);
      print(element.doneTimestamp);
      box.delete(element.id);
    });

    print('after delete');
    box.values.forEach((element) {
      print(element.id);
    });
  }
}
