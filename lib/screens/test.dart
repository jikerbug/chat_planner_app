import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class Pool extends StatelessWidget {
  final keys = GlobalKey<AnimatedListState>();
  var list = List.generate(3, (i) => "Hello $i");

  @override
  Widget build(BuildContext context) {
    int idx = 1;
    return Scaffold(
      body: SafeArea(
        child: AnimatedList(
          key: keys,
          initialItemCount: list.length,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: animation.drive(
                  Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                      .chain(CurveTween(curve: Curves.ease))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {},
                  leading: Badge(
                    animationType: BadgeAnimationType.scale,
                    position: BadgePosition.bottomEnd(),
                    badgeColor: Colors.teal,
                    badgeContent: Text(
                      '1',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Badge(
                      animationType: BadgeAnimationType.scale,
                      badgeContent: Text(
                        '3',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.teal,
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            '0회',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                          radius: 25,
                        ),
                      ),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        list[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        list[index],
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          list.insert(0, "나와의 채팅");
          keys.currentState!.insertItem(0, duration: Duration(seconds: 2));
          keys.currentState!.removeItem(
            list.length - idx,
            (context, animation) => SlideTransition(
              position: animation.drive(
                  Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                      .chain(CurveTween(curve: Curves.ease))),
              child: ListTile(
                onTap: () {},
                leading: Badge(
                  animationType: BadgeAnimationType.scale,
                  position: BadgePosition.bottomEnd(),
                  badgeColor: Colors.teal,
                  badgeContent: Text(
                    '1',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Badge(
                    animationType: BadgeAnimationType.scale,
                    badgeContent: Text(
                      '3',
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: Colors.teal,
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          '0회',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        radius: 25,
                      ),
                    ),
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      list[list.length - idx],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      list[list.length - idx],
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ],
                ),
              ),
            ),
            duration: Duration(seconds: 2),
          );
          list.remove(list.length - idx);
          idx++;
        },
      ),
    );
  }
}
