import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;

  final DateTime lastMessageTime;

  const User({
    required this.idUser,
    required this.name,
    required this.lastMessageTime,
  });
}
