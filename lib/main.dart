import 'package:chat_planner_app/screens/bottom_nav_route/main_route_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'api/firebase_plan_api.dart';
import 'api_in_local/plan_api.dart';
import 'models/plan_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp();
  FirebasePlanApi.setDbRef(app);

  await Hive.initFlutter();
  Hive.registerAdapter(PlanModelAdapter());
  await Hive.openBox<PlanModel>('word');

  runApp(MaterialApp(
    title: '챗플래너',
    theme: ThemeData(
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
    // return FutureBuilder(
    //     future: PlanApi.getPlans(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         Map plan = snapshot.data as Map;
    return MainRouteScreen(
        tasks: {}, userInfo: {'userId': 'mindnetworkcorp@gmail'});
    //   } else {
    //     return buildLoading();
    //   }
    // });
  }
}

Widget buildLoading() => Container(
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
