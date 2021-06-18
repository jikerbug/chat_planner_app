import 'package:flutter/material.dart';

class CircleBorderBox extends StatelessWidget {
  CircleBorderBox(
      {required this.radius,
      required this.title,
      required this.borderColor,
      required this.textColor,
      required this.backGroundColor});

  final double radius;
  final String title;
  final Color borderColor;
  final Color textColor;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: (radius == -1.0)
          ? CircleAvatar(
              backgroundColor: backGroundColor,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            )
          : CircleAvatar(
              radius: radius,
              backgroundColor: backGroundColor,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
    );
  }
}
