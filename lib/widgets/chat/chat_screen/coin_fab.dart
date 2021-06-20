import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoinFAB extends StatefulWidget {
  CoinFAB(
      {required this.coinCount,
      required this.myCoinCount,
      required this.friendCoinCount});
  final int coinCount;
  final int myCoinCount;
  final int friendCoinCount;

  @override
  _CoinFABState createState() => _CoinFABState();
}

class _CoinFABState extends State<CoinFAB> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation unfoldAnimation;
  late Animation rotationAnimation;
  double hiddenButtonElevation = 0.0;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    unfoldAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
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
    int coinCount = widget.coinCount;
    int myCoinCount = widget.myCoinCount;
    int otherCoinCount = widget.friendCoinCount;
    return Stack(
      children: [
        Positioned(
          left: 40,
          top: AppBar().preferredSize.height * 2,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset.fromDirection(
                    getRadiansFromDegree(90), unfoldAnimation.value * 60),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  elevation: hiddenButtonElevation,
                  onPressed: () {
                    //Navigator.pushNamed(context, TaskScreen.id);
                  },
                  icon: Icon(Icons.perm_identity_outlined),
                  backgroundColor: Colors.green,
                  label: Text("응원한 사람 : 혁구"),
                ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(
                    getRadiansFromDegree(90), unfoldAnimation.value * 120),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  elevation: hiddenButtonElevation,
                  onPressed: () {
                    //Navigator.pushNamed(context, TaskScreen.id);
                  },
                  icon: Icon(Icons.accessibility, color: Colors.black),
                  backgroundColor: Colors.white,
                  label: Text(
                    "응원받은 사람 : 지백",
                    style: TextStyle(color: Colors.black),
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
                    child: Icon(Icons.attach_money)),
                backgroundColor: Colors.teal,
                label: Text("푸시업 30개 계획을 응원중"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
