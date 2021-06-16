import 'package:chat_planner_app/models/plan.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/side_nav_route/side_nav.dart';
import 'package:chat_planner_app/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../plan_add_screen.dart';
import '../plan_screen.dart';

import 'package:chat_planner_app/api/firestore_heart_api.dart';

class MainRouteScreen extends StatefulWidget {
  MainRouteScreen({
    required this.userInfo,
    required this.tasks,
  });
  final Map userInfo;
  final Map tasks;
  static const String id = 'main_route_screen';

  @override
  _MainRouteScreenState createState() => _MainRouteScreenState();
}

class _MainRouteScreenState extends State<MainRouteScreen> {
  static late String userId;
  static late Data providerData;

  @override
  void initState() {
    super.initState();
    userId = widget.userInfo['userId'];
  }

  @override
  Widget build(BuildContext context) {
    providerData = Data(
      mainRouteContext: context,
      userId: widget.userInfo['userId'],
    );

    //할일 목록 가져오기
    List<Plan> tasks = [];
    String title;
    bool isChecked;
    String timestamp;
    int index;

    Map<dynamic, dynamic> map = widget.tasks;

    map.forEach((key, value) {
      title = value['title'];
      isChecked = value['isChecked'];
      timestamp = value['timestamp'];
      index = 0;

      tasks.add(Plan(
          title: title,
          isChecked: isChecked,
          timestamp: timestamp,
          index: index));
    });

    tasks.sort((a, b) {
      return a.compareTo(b);
    });
    providerData.setTaskList(tasks);

    //유저정보가져오기
    providerData.setUserInfo(widget.userInfo);

    return ChangeNotifierProvider<Data>(
      create: (context) => providerData,
      child: MaterialApp(
        // MaterialApp은 라우트를 통해 화면을 구성한다.
        home: Home(userId: userId),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({this.userId});
  final userId;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navigatorKey = GlobalKey<NavigatorState>();
  int totalCoinCount = 0;
  int prevTotalCoinCount = 0;
  int totalHeartCount = 0;

  String appBarTitle = '홈';
  void changeAppBarTitle(title) {
    setState(() {
      appBarTitle = title;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Function myHeartCallback = (getHeartCount) {
      print('sadas');
      if (!mounted) return;
      setState(() {
        totalHeartCount = getHeartCount;
      });
    };
    print(widget.userId);
    FireStoreHeartApi.heartCountListener(widget.userId, myHeartCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.4, 0.5],
          colors: [
            Colors.green[300]!,
            Colors.green[700]!,
            Colors.green[800]!,
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          //앱바 없어도 이거 사용가능...!!!
          drawer: Drawer(
            child: SideNav(),
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // appBar: AppBar(
          //     backgroundColor: Colors.green,
          //     title: Text(appBarTitle),
          //     actions: [
          //       Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0),
          //         child: MaterialButton(
          //           shape: RoundedRectangleBorder(
          //               borderRadius: new BorderRadius.circular(30.0)),
          //           minWidth: 50.0,
          //           onPressed: () {},
          //           elevation: 10.0,
          //           color: Colors.teal,
          //           child: Row(
          //             children: [
          //               Icon(
          //                 Icons.badge,
          //                 color: Colors.yellow,
          //               ),
          //               SizedBox(
          //                 width: 5.0,
          //               ),
          //               Text(
          //                 '1',
          //                 style: TextStyle(
          //                     fontSize: 18.0,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10.0,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0),
          //         child: MaterialButton(
          //           shape: RoundedRectangleBorder(
          //               borderRadius: new BorderRadius.circular(30.0)),
          //           minWidth: 50.0,
          //           onPressed: () {},
          //           elevation: 10.0,
          //           color: Colors.black54,
          //           child: Row(
          //             children: [
          //               Icon(
          //                 Icons.favorite,
          //                 color: Colors.red,
          //               ),
          //               SizedBox(
          //                 width: 5.0,
          //               ),
          //               Text(
          //                 '$totalHeartCount',
          //                 style: TextStyle(
          //                     fontSize: 18.0,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       // CoinAccount(
          //       //   totalCoinCount: totalCoinCount,
          //       //   prevTotalCoinCount: prevTotalCoinCount,
          //       // ),
          //       SizedBox(
          //         width: 10.0,
          //       )
          //     ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true, //full screen으로 modal 쓸 수 있게 해준다.
                context: context,
                builder: (context) => PlanAddScreen(),
              );
            },
          ),
          backgroundColor: Colors.transparent,
          body: Navigator(
            key: navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder = (context) => PlanScreen();
              switch (settings.name) {
                case '/':
                  builder = (context) => PlanScreen();
                  break;
              }
              return MaterialPageRoute(
                builder: builder,
                settings: settings,
              );
            },
          ),
          bottomNavigationBar: BottomBar(
              navigatorKey: navigatorKey,
              appBarCallback: changeAppBarTitle,
              userId: widget.userId),
        ),
      ),
    );
  }
}
