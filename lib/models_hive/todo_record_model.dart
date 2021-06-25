import 'package:hive/hive.dart';

part 'todo_record_model.g.dart';

@HiveType(typeId: 4)
class TodoRecordModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String doneTimestamp;

  @HiveField(2)
  final String planCreatedTime;

  @HiveField(3)
  final String title;

  TodoRecordModel({
    required this.id,
    required this.doneTimestamp,
    required this.planCreatedTime,
    required this.title,
  });
}
