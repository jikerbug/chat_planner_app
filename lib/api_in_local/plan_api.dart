import 'dart:io';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class PlanApi {
  static Database? _database;

  //singleton //사실 그냥 처음에 앱 시작할때 _database를 init하면 되네...
  static Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database!;
  }

  static Future<Database> initDatabase() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String dbPath = appDocDirectory.path + '/plan.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    return await dbFactory.openDatabase(dbPath);
  }

  static Future<Map> getPlans() async {
    var store = StoreRef.main();
    Database db = await PlanApi.database;
    var records = await store.find(db);

    Map habitMap = {};
    int id = 0;
    records.forEach((element) {
      habitMap.putIfAbsent(id, () => element);
      id++;
    });
    print(records);
    print(habitMap);

    return habitMap;
  }

  static void deletePlan(timestamp) async {
    Database db = await PlanApi.database;
    var store = StoreRef.main();
    store.delete(db,
        finder: Finder(filter: Filter.equals('timestamp', timestamp)));
  }

  static void toggleCheckBox(timestamp, bool value) async {
    var store = StoreRef.main();
    Database db = await PlanApi.database;
    print(value);
    var record = await store.find(db,
        finder: Finder(filter: Filter.equals('timestamp', timestamp)));

    var newRecord = {
      'title': record[0]['title'],
      'isChecked': value,
      'timestamp': timestamp
    };

    await store.update(db, newRecord,
        finder: Finder(filter: Filter.equals('timestamp', timestamp)));
  }

  static void reOrderPlan(newIndex, newIndexTimestamp, timestamp) async {
    //이거 작동 안함,,,, (시간을 평균내는 것,, 실패함)
    var store = StoreRef.main();
    Database db = await PlanApi.database;
    var record = await store.find(db,
        finder: Finder(filter: Filter.equals('timestamp', timestamp)));

    var oldTimestamp = DateTime.parse(timestamp);
    var newTimestamp = DateTime.parse(newIndexTimestamp);

    int microCalc = (oldTimestamp.microsecondsSinceEpoch ~/ 2 +
        newTimestamp.microsecondsSinceEpoch ~/ 2);
    DateTime resultTimestamp = DateTime(2021, 0, 0, 0, 0, 0, 0, microCalc);

    print(newTimestamp);
    print(timestamp);
    print(resultTimestamp);
    return;
    var newRecord = {
      'title': record[0]['title'],
      'isChecked': record[0]['title'],
      'timestamp': newTimestamp.toString()
    };

    await store.update(db, newRecord,
        finder: Finder(filter: Filter.equals('timestamp', timestamp)));
  }

  static void addPlan(title, time, planLength) async {
// dynamically typed store
    var store = StoreRef.main();
    Database db = await PlanApi.database;
    await store.add(db, {
      'title': title,
      'timestamp': time,
      'isChecked': false,
      'index': planLength
    });
  }
// value = 'my_value'

}
