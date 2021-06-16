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

  PlanTile({
    required this.key,
    required this.userId,
    required this.isChecked,
    required this.title,
    required this.index,
    required this.timestamp,
  });

  @override
  _PlanTileState createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Data>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Material(
        key: widget.key,
        elevation: 4.0,
        child: Stack(
          children: [
            ListTile(
              leading: widget.isChecked
                  ? GestureDetector(child: Icon(Icons.check), onTap: () {})
                  : GestureDetector(
                      child: GestureDetector(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onTap: () {},
                      ),
                      onTap: () {},
                    ),
              title: widget.isChecked == false
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                                decoration: widget.isChecked
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                          if (widget.index == 0) ...[
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
                        ])
                  : Text(
                      widget.title,
                      style: TextStyle(
                          decoration: widget.isChecked
                              ? TextDecoration.lineThrough
                              : null),
                    ),
              trailing: Checkbox(
                activeColor: Colors.green,
                value: widget.isChecked,
                onChanged: (value) {
                  if (value == true) {
                    providerData.toggleCheckBox(widget.index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
