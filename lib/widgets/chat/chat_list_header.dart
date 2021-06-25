import 'package:flutter/material.dart';

class FriendsHeader extends StatefulWidget {
  final List<String> texts;
  const FriendsHeader({
    required this.texts,
  });

  @override
  _FriendsHeaderState createState() => _FriendsHeaderState();
}

class _FriendsHeaderState extends State<FriendsHeader> {
  late String selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.texts[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, bottom: 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.texts.length,
              itemBuilder: (context, index) {
                final text = widget.texts[index];

                return Material(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  color: (selectedGroup == text)
                      ? Colors.white
                      : Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGroup = text;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Text(
                        text,
                        style: TextStyle(
                            color: (selectedGroup == text)
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                width: 10.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
