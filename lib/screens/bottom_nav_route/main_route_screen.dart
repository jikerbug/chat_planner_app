import 'package:chat_planner_app/screens/chat/chat_search_screen.dart';

import '../../models_singleton/user.dart';
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
    User user = User();
    userId = widget.userInfo['userId'];
    user.setUserId(userId);
  }

  @override
  Widget build(BuildContext context) {
    providerData = Data(mainRouteContext: context, userId: userId);

    //유저정보가져오기
    providerData.setUserInfo(widget.userInfo);

    return ChangeNotifierProvider<Data>(
      create: (context) => providerData,
      child: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home();

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

    print(User().userId);
    FireStoreHeartApi.heartCountListener(User().userId, myHeartCallback);
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
          drawer: Drawer(
            child: SideNav(),
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.teal,
              child: fabType == ChatListScreen.id
                  ? Icon(Icons.search)
                  : Icon(Icons.add),
              onPressed: fabType == ChatListScreen.id
                  ? () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => ChatSearchScreen(),
                        ),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => PlanAddScreen(),
                        ),
                      );

                      // showModalBottomSheet(
                      //   isScrollControlled:
                      //       true, //full screen으로 modal 쓸 수 있게 해준다.
                      //   context: context,
                      //   builder: (context) => PlanAddScreen(),
                      // );
                    }),
          backgroundColor: Colors.transparent,
          body: Navigator(
            key: navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder = (context) => PlanScreen(
                    fabFunc: changeFAB,
                  );
              switch (settings.name) {
                case '/':
                  builder = (context) => PlanScreen(fabFunc: changeFAB);
                  break;
                case '/chats':
                  builder = (context) => ChatListScreen(fabCallback: changeFAB);
                  break;
              }
              return NoDelayPageRoute(
                builder: builder,
                settings: settings,
              );
            },
          ),
          bottomNavigationBar: BottomBar(navigatorKey: navigatorKey),
        ),
      ),
    );
  }
}

class NoDelayPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  NoDelayPageRoute({builder, settings})
      : super(builder: builder, settings: settings);
}
