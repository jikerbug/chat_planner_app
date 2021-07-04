import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 4)
class UserModel {
  @HiveField(0)
  final int id;

  @HiveField(2)
  final String lastCheckInDate;

  @HiveField(3)
  final String userId;

  UserModel({
    required this.id,
    required this.lastCheckInDate,
    required this.userId,
  });
}
