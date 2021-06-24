import 'package:hive/hive.dart';

part 'record_model.g.dart';

@HiveType(typeId: 2)
class RecordModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String doneTimestamp;

  RecordModel({
    required this.id,
    required this.doneTimestamp,
  });
}
