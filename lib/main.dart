import 'package:chat_planner_app/screens/bottom_nav_route/main_route_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'models/plan_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/record_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(PlanModelAdapter());
  Hive.registerAdapter(RecordModelAdapter());
  await Hive.openBox<PlanModel>('plan');
  await Hive.openBox<RecordModel>('record');

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
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MainRouteScreen(userInfo: {'userId': 'mindnetworkcorp@gmail'});
  }
}

Widget buildLoading() => Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
