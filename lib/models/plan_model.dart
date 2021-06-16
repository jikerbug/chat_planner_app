import 'package:hive/hive.dart';

part 'plan_model.g.dart';

@HiveType(typeId: 1)
class PlanModel {
  @HiveField(0)
  final int id;
  //id는 작명이 다소 헷갈릴 소지가 있다.
  //id는 key값을 간편하게 불러와서 reorder가 잘 되었는지 확인하기 위한 value이다.
  //사실 없어도 문제없다. 어짜피 계속 바뀌는 값임...
  //진짜 id는 사실 timestamp를 통해 구별될 것이다.

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isChecked;

  @HiveField(3)
  final String timestamp;

  @HiveField(4)
  final bool isOneTimeTask;

  @HiveField(5)
  final List aimDaysOfWeek;

  PlanModel({
    required this.id,
    required this.title,
    required this.isChecked,
    required this.timestamp,
    required this.isOneTimeTask,
    required this.aimDaysOfWeek,
  });
}
