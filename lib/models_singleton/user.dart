class User {
  static final User _singleton = User._internal();
  late String _userId;
  late String _nickname;

  factory User() {
    return _singleton;
  }

  User._internal() {
    this._userId = 'not_fetched';
    this._nickname = 'not_fetched';
  }
  void setUserId(String userId) {
    _userId = userId;
  }

  void setNickname(String nickname) {
    _nickname = nickname;
  }

  String get userId => _userId;
  String get nickname => _nickname;
}
