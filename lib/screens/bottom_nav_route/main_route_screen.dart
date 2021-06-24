import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/screens/chat/chat_list_sceen.dart';
import 'package:chat_planner_app/screens/side_nav_route/side_nav.dart';
import 'package:chat_planner_app/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../plan/plan_add_screen.dart';
import '../plan/plan_screen.dart';

import 'package:chat_planner_app/api/firestore_heart_api.dart';

class MainRouteScreen extends StatefulWidget {
  MainRouteScreen({
    required this.userInfo,
  });
  final Map userInfo;
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

    //유저정보가져오기
    providerData.setUserInfo(widget.userInfo);

    return ChangeNotifierProvider<Data>(
      create: (context) => providerData,
      child: Home(userId: userId),
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

  String fabType = 'addPlan';

  void changeFAB(fabType) {
    setState(() {
      this.fabType = fabType;
    });
  }

  @override
  void initState() {
    super.initState();
    Function myHeartCallback = (getHeartCount) {
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
    Icon fabIcon;
    if (fabType == PlanScreen.id) {
      fabIcon = Icon(Icons.add);
    } else if (fabType == ChatListScreen.id) {
      fabIcon = Icon(Icons.search);
    } else {
      fabIcon = Icon(Icons.add);
    }

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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            child: fabIcon,
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
              WidgetBuilder builder =
                  (context) => PlanScreen(fabFunc: changeFAB);
              switch (settings.name) {
                case '/':
                  builder = (context) => PlanScreen(fabFunc: changeFAB);
                  break;
                case '/chats':
                  builder = (context) => ChatListScreen(fabFunc: changeFAB);
                  break;
              }
              return MaterialPageRoute(
                builder: builder,
                settings: settings,
              );
            },
          ),
          bottomNavigationBar:
              BottomBar(navigatorKey: navigatorKey, userId: widget.userId),
        ),
      ),
    );
  }
}
