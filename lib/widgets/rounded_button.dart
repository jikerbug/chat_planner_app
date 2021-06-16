import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.color,
      required this.title,
      required this.onPressed,
      this.minWidth = 100.0,
      this.textColor = Colors.white});

  final Color color;
  final String title;
  final void Function() onPressed;
  final double minWidth;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(25.0),
        elevation: 5.0,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          onPressed: onPressed,
          minWidth: minWidth,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
