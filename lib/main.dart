import 'package:chat_planner_app/api/firebase_chat_api.dart';
import 'package:chat_planner_app/constants.dart';
import 'package:chat_planner_app/models_hive/chat_room_model.dart';
import 'package:chat_planner_app/screens/bottom_nav_route/main_route_screen.dart';
import 'package:chat_planner_app/screens/chat/chat_screen.dart';
import 'package:chat_planner_app/screens/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'api_in_local/hive_record_api.dart';
import 'models_hive/plan_model.dart';
import 'models_hive/record_model.dart';
import 'models_hive/todo_record_model.dart';
import 'models_hive/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(PlanModelAdapter());
  Hive.registerAdapter(RecordModelAdapter());
  Hive.registerAdapter(TodoRecordModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChatRoomModelAdapter());
  await Hive.openBox<PlanModel>('plan');
  await Hive.openBox<RecordModel>('record');
  await Hive.openBox<TodoRecordModel>(kTodoRecordBoxName);
  await Hive.openBox<UserModel>('user');

  int reverseOrder(k1, k2) {
    if (k1 > k2) {
      return -1;
    } else if (k1 < k2) {
      return 1;
    } else {
      return 0;
    }
  }

  await Hive.openBox<ChatRoomModel>('chatRoom', keyComparator: reverseOrder);

  final planBox = Hive.box<PlanModel>('plan');
  planBox.values.forEach((PlanModel element) async {
    //TODO:planEndDate가 지나고 1주일이 지난 놈들은 안불러온다.
    await HiveRecordApi.openHabitRecordBox(
        element.createdTime, element.isHabit);
  });
  // FirebaseChatApi.test();
  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ko', 'KO'),
    ],
    debugShowCheckedModeBanner: false,
    title: '챗플래너',
    theme: ThemeData(
      primaryColor: Colors.green,
      primarySwatch: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: MainRouteScreen.id,
    routes: {
      MainRouteScreen.id: (context) => MainRouteScreen(userInfo: {
            'userId': 'mindnetworkcorp@gmail',
          }),
      //mainRoute end
      ChatScreen.id: (context) => ChatScreen(),
    },
  ));
}

Widget buildLoading() => Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
