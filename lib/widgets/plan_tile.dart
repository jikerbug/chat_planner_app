import 'package:chat_planner_app/providers/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanTile extends StatefulWidget {
  final bool isChecked;
  final String title;
  final int index;
  final String timestamp;
  final String userId;
  final Key key;
  final void Function() deleteFunction;
  final void Function(dynamic) checkFunction;

  PlanTile({
    required this.key,
    required this.userId,
    required this.isChecked,
    required this.title,
    required this.index,
    required this.timestamp,
    required this.deleteFunction,
    required this.checkFunction,
  });

  @override
  _PlanTileState createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  bool isPromised = true;
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Data>(context, listen: false);

    return Container(
      child: Material(
        //Material 없애면 화면 이상해짐
        key: widget.key,
        child: Stack(
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: widget.isChecked
                  ? GestureDetector(child: Icon(Icons.check), onTap: () {})
                  : GestureDetector(
                      child: GestureDetector(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onTap: widget.deleteFunction,
                      ),
                      onTap: () {},
                    ),
              title: widget.isChecked == false
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                          if (isPromised) ...[
                            GestureDetector(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.grey,
                              ),
                              onTap: () {},
                            ),
                          ] else ...[
                            GestureDetector(
                              child: Icon(
                                Icons.pause_circle_outline,
                                color: Colors.grey,
                              ),
                              onTap: () {},
                            ),
                          ],
                          Text(
                            widget.title + ' 하기',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                decoration: widget.isChecked
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                        ])
                  : Text(
                      widget.title + ' 하기',
                      style: TextStyle(
                          fontSize: 17.0,
                          decoration: widget.isChecked
                              ? TextDecoration.lineThrough
                              : null),
                    ),
              trailing: Checkbox(
                value: widget.isChecked,
                onChanged: (value) {
                  widget.checkFunction(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
