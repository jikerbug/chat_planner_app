import 'package:flutter/material.dart';

class ChatCategoryHeader extends StatefulWidget {
  final List<String> texts;
  final Color color;
  const ChatCategoryHeader({required this.texts, this.color = Colors.white});

  @override
  _ChatCategoryHeaderState createState() => _ChatCategoryHeaderState();
}

class _ChatCategoryHeaderState extends State<ChatCategoryHeader> {
  late String selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.texts[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, bottom: 0, right: 10.0),
      width: double.infinity,
      child: Container(
        height: MediaQuery.of(context).size.width / 9,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.texts.length,
          itemBuilder: (context, index) {
            final text = widget.texts[index];

            return Material(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              color:
                  (selectedGroup == text) ? widget.color : Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGroup = text;
                  });
                },
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 9,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                          color: (selectedGroup == text)
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
            width: 10.0,
          ),
        ),
      ),
    );
  }
}
