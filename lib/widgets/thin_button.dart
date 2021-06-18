import 'package:flutter/material.dart';

class ThinButton extends StatelessWidget {
  ThinButton(
      {required this.onPressed, required this.title, required this.color});

  final void Function() onPressed;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(new Radius.circular(50.0)),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 10.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ))),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
