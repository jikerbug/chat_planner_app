import 'package:firebase_database/firebase_database.dart';

class FirebasePlanApi {
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final DatabaseReference plansRef = database.reference().child('plans');

  static Future<Map> getTasks(String userId) async {
    //print((await plansRef.child(userId).once()).value);
    return (await plansRef.child(userId).once()).value;
  }

  static void deleteTask(String userId, String timestamp) {
    plansRef
        .child(userId)
        .orderByChild('timestamp')
        .equalTo(timestamp)
        .onChildAdded
        .listen((Event event) {
      print(event.snapshot.value);
      FirebaseDatabase.instance
          .reference()
          .child('tasks')
          .child(userId)
          .child(event.snapshot.key!)
          .remove();
      print(timestamp);
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      print('Error: ${error.code} ${error.message}');
    });
  }

  static void doTaskAgain(title, userId, timestamp, chatRoomId, friendUserId) {
    plansRef
        .child(userId)
        .orderByChild('timestamp')
        .equalTo(timestamp)
        .onChildAdded
        .listen((Event event) async {
      print(event.snapshot.value);

      int checkCount = (await plansRef
                  .child(userId)
                  .child(event.snapshot.key!)
                  .child('checkCount')
                  .once())
              .value ??
          0;

      FirebaseDatabase.instance
          .reference()
          .child('tasks')
          .child(userId)
          .child(event.snapshot.key!)
          .update({'isChecked': false, 'checkCount': checkCount + 1});
      print(timestamp);

      // FireStoreApi.sendAddAgainMessages(
      //     title, userId, chatRoomId, checkCount + 1, friendUserId);
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      print('Error: ${error.code} ${error.message}');
    });
  }

  static void addTask(title, userId, timestamp) {
    print(userId);
    String time = timestamp.toString();

    plansRef.child(userId).push().set({
      'title': title,
      'timestamp': time,
      'isChecked': false,
    });
    // FireStoreApi.sendAddMessages(
    //     title, selectedCategory, userId, chatRoomId, friendUserId);
  }

  //일단 이함수는 무조건 true일때만 실행하는 것으로 한다!
  static void toggleCheckBox(
      String userId, String timestamp, bool value) async {
    print('cocacola');
    plansRef
        .child(userId)
        .orderByChild('timestamp')
        .equalTo(timestamp)
        .onChildAdded
        .listen((Event event) {
      print(event.snapshot.value);
      plansRef
          .child(userId)
          .child(event.snapshot.key!)
          .child('isChecked')
          .set(value);
    }, onError: (Object o) {
      final DatabaseError error = o as DatabaseError;
      print('Error: ${error.code} ${error.message}');
    });
  }
}
