import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/models_hive/plan_model.dart';
import 'package:chat_planner_app/models_hive/todo_record_model.dart';
import 'package:hive/hive.dart';
import '../constants.dart';

class HiveTodoRecordApi {
  static Future<void> addRecord({
    required PlanModel item,
    required doneTimestamp,
  }) async {}
}
