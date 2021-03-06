import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBar({this.navigatorKey});
  final navigatorKey;
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  bool isChatRoomStateChanged = false;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;

    Function isChatRoomStateChangedCallback = (getIsChatRoomStateChanged) {
      setState(() {
        isChatRoomStateChanged = getIsChatRoomStateChanged;
      });
    };
    // FirebaseChatApi.isChatRoomStateChangedListener(
    //     widget.userId, isChatRoomStateChangedCallback);
  }

  void changePage(int index, currentContext) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        widget.navigatorKey.currentState.pushNamed('/');
        break;
      case 1:
        widget.navigatorKey.currentState.pushNamed('/chats');
        break;
      case 2:
        widget.navigatorKey.currentState.pushNamed('/cheers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
        )
      ]),
      child: BottomNavigationBar(
        elevation: 100.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: currentIndex, //현재 선택된 Index
        onTap: (int index) {
          if (index != currentIndex) {
            changePage(index, context);
          }
        },
        items: [
          BottomNavigationBarItem(
            label: '홈',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: '실천채팅',
            icon: isChatRoomStateChanged
                ? Stack(children: <Widget>[
                    Icon(Icons.chat),
                    Positioned(
                      // draw a red marble
                      top: -1.0,
                      right: -1.0,
                      child: new Icon(Icons.brightness_1,
                          size: 10.0, color: Colors.redAccent),
                    )
                  ])
                : Icon(Icons.chat),
          ),
          // BottomNavigationBarItem(
          //   label: '실천친구',
          //   icon: Icon(Icons.people),
          // ),
          BottomNavigationBarItem(
            label: '응원함',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
