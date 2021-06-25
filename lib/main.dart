import 'package:chat_planner_app/screens/bottom_nav_route/main_route_screen.dart';
import 'package:chat_planner_app/screens/chat/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'api_in_local/hive_record_api.dart';
import 'models_hive/plan_model.dart';
import 'models_hive/record_model.dart';
import 'models_hive/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(PlanModelAdapter());
  Hive.registerAdapter(RecordModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<PlanModel>('plan');
  await Hive.openBox<RecordModel>('record');
  await Hive.openBox<UserModel>('user');
  final planBox = Hive.box<PlanModel>('plan');
  planBox.values.forEach((element) async {
    await HiveRecordApi.openPlanRecordBox(element.createdTime);
  });

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
    home: MyApp(),
    initialRoute: MainRouteScreen.id,
    routes: {
      MainRouteScreen.id: (context) => MainRouteScreen(userInfo: {
            'userId': 'mindnetworkcorp@gmail',
            'profileUrl': 'no_profile_image'
          }),
      //mainRoute end
      ChatScreen.id: (context) => ChatScreen(),
    },
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainRouteScreen(userInfo: {
      'userId': 'mindnetworkcorp@gmail',
      'profileUrl': 'no_profile_image'
    });
  }
}

Widget buildLoading() => Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
