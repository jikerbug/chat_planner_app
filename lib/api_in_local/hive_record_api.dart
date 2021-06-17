import 'package:chat_planner_app/functions/datetime_function.dart';
import 'package:chat_planner_app/models/record_model.dart';
import 'package:hive/hive.dart';

class HiveRecordApi {
  static final box = Hive.box<RecordModel>('record');

  static void addRecord({
    required planTimestampId,
    required doneTimestamp,
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
      RecordModel(
        id: id,
        planTimestampId: planTimestampId,
        doneTimestamp: doneTimestamp,
      ),
    );

    box.values.forEach((element) {
      print(element.id);
    });
  }

  static void deleteRecordOfToday(
      {required String planTimestampId, required String deleteTimestamp}) {
    print('before delete');
    box.values.forEach((element) {
      print(element.id);
    });
    box.values
        .where((element) =>
            element.planTimestampId == planTimestampId &&
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
