import 'package:cloud_firestore/cloud_firestore.dart';

//coin의 경우는, 최대적립개수 제한이 있기 때문에 이를 체크하기 위한 읽기 + 쓰기작업이 필요했다.
//하지만 하트가 '추가'되는 경우에는 그냥 +만 해주면 되기 때문에 firestore에서 제공하는 increment를 사용할 수 있다.
//하지만,,, 하트는 하루에 한번만 선물할 수 있기 때문에 역시 읽기 작업이 필요하다니,,,,,
//아니다. 어차피 하루에 쌓는 코인이 제한되어있는데 거기에 하트까지 제한을 걸 필요는 없다. 어차피 간접적 제한이 걸려있는 셈이니까

class FireStoreHeartApi {
  static final _fireStore = FirebaseFirestore.instance;

  static void setDefaultHeart(userId) {
    _fireStore.collection('assets').doc(userId).set({
      'heartCount': 0,
    });
  }

  static Future<int> getHeart(userId) async {
    DocumentSnapshot ds =
        await _fireStore.collection('assets').doc(userId).get();
    Map data = ds.data() as Map;
    int heartCount = data['heartCount'];
    return heartCount;
  }

  static void heartIncrement(userId) {
    _fireStore
        .collection('assets')
        .doc(userId)
        .update({"heartCount": FieldValue.increment(1)});
  }

  static void heartCountListener(userId, callback) {
    _fireStore.collection("assets").doc(userId).snapshots().listen((event) {
      if (event.data() != null) {
        Map data = event.data() as Map;
        callback(data["heartCount"]);
      }
    });
  }

  static Future<List<int>> fetchHeartCountRankList(callback) async {
    List<int> rankList = [];
    QuerySnapshot qs = await _fireStore
        .collection('assets')
        .orderBy('heartCount', descending: true)
        .limit(10)
        .get();
    for (DocumentSnapshot doc in qs.docs) {
      Map data = doc.data() as Map;
      rankList.add(data['heartCount']);
    }
    callback(rankList);
    print('heartRankFetched');
    return rankList;
  }
}
