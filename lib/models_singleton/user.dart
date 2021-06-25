class User {
  static final User _singleton = User._internal();
  late String _userId;

  factory User() {
    return _singleton;
  }

  User._internal() {
    this._userId = 'not_fetched';
  }
  void setUserId(String userId) {
    _userId = userId;
  }

  String get userId => _userId;
}
