import 'package:chat_planner_app/providers/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanTile extends StatefulWidget {
  final Key key;
  final bool isChecked;
  final String title;
  final int index;
  final String timestamp;
  final String type;
  final void Function() deleteFunction;
  final void Function(dynamic) checkFunction;

  PlanTile({
    required this.key,
    required this.isChecked,
    required this.title,
    required this.index,
    required this.timestamp,
    required this.type,
    required this.deleteFunction,
    required this.checkFunction,
  });

  @override
  _PlanTileState createState() => _PlanTileState();
}

class _PlanTileState extends State<PlanTile> {
  bool isPromised = true;
  late Widget leadingWidget;

  Widget donePlanLeading() {
    return GestureDetector(child: Icon(Icons.check), onTap: () {});
  }

  Widget notDonePlanLeading() {
    return GestureDetector(
      child: SvgPicture.asset(
        //svg가 안되는 경우, svg파일에 null이라는 단어가 있는지 확인. 있다면 none으로 변경
        'assets/images/stamp_real_4.svg',
        color: Colors.grey,
      ),
      onTap: widget.deleteFunction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Data>(context, listen: false);
    if (widget.isChecked) {
      //initState에서 해주면 안됨(key가 같아서 객체로 취급되는듯)
      leadingWidget = donePlanLeading();
    } else {
      leadingWidget = notDonePlanLeading();
    }
    return Material(
      //Material 없애면 화면 이상해짐
      key: widget.key,
      child: Stack(
        children: [
          ListTile(
            tileColor: Colors.white,
            leading: AspectRatio(aspectRatio: 1.0, child: leadingWidget),
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
    );
  }
}
