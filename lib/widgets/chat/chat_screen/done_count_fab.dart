import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoneCountFAB extends StatefulWidget {
  DoneCountFAB(
      {required this.coinCount,
      required this.myCoinCount,
      required this.friendCoinCount});
  final int coinCount;
  final int myCoinCount;
  final int friendCoinCount;

  @override
  _DoneCountFABState createState() => _DoneCountFABState();
}

class _DoneCountFABState extends State<DoneCountFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation unfoldAnimation;
  late Animation rotationAnimation;
  double hiddenButtonElevation = 0.0;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    unfoldAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 0.0, end: 90.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 40,
          top: AppBar().preferredSize.height * 2,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset.fromDirection(
                    getRadiansFromDegree(90), unfoldAnimation.value * 120),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  elevation: hiddenButtonElevation,
                  onPressed: () {
                    //Navigator.pushNamed(context, TaskScreen.id);
                  },
                  backgroundColor: Colors.white,
                  label: Text(
                    "총 42002회 실천",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(
                    getRadiansFromDegree(90), unfoldAnimation.value * 60),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  elevation: hiddenButtonElevation,
                  onPressed: () {
                    //Navigator.pushNamed(context, TaskScreen.id);
                  },
                  backgroundColor: Colors.green,
                  label: Text(
                    "금주 100회 실천",
                  ),
                ),
              ),
              FloatingActionButton.extended(
                elevation: 10.0,
                onPressed: () {
                  if (animationController.isCompleted) {
                    animationController.reverse();
                    setState(() {
                      hiddenButtonElevation = 0.0;
                    });
                  } else {
                    setState(() {
                      hiddenButtonElevation = 5.0;
                    });
                    animationController.forward();
                  }
                },
                icon: Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value)),
                    alignment: Alignment.center,
                    child: Icon(Icons.people)),
                backgroundColor: Colors.teal,
                label: Text("금일 32회 실천"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
