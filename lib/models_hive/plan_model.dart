import 'package:hive/hive.dart';

part 'plan_model.g.dart';

@HiveType(typeId: 1)
class PlanModel {
  @HiveField(0)
  final int id;
  //id는 작명이 다소 헷갈릴 소지가 있다.
  //id는 key값을 간편하게 불러와서 reorder가 잘 되었는지 확인하기 위한 value이다.
  //진짜 id는 timestamp를 통해 구별될 것이다.

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isChecked;

  @HiveField(3)
  final String createdTime;

  @HiveField(4)
  final bool isHabit;

  @HiveField(5)
  final List aimDaysOfWeek;

  @HiveField(6)
  final String planEndDate;

  @HiveField(7)
  final String selectedChatRoomId;

  PlanModel({
    required this.id,
    required this.title,
    required this.isChecked,
    required this.createdTime,
    required this.isHabit,
    required this.aimDaysOfWeek,
    required this.planEndDate,
    required this.selectedChatRoomId,
  });
}
