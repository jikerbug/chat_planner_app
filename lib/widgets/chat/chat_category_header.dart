import 'package:flutter/material.dart';

class ChatCategoryHeader extends StatelessWidget {
  const ChatCategoryHeader(
      {required this.texts,
      required this.selectCategoryCallback,
      required this.category,
      this.color = Colors.white});

  final List<String> texts;
  final Color color;
  final Function selectCategoryCallback;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, bottom: 0, right: 10.0),
      width: double.infinity,
      child: Container(
        height: MediaQuery.of(context).size.width / 9,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: texts.length,
          itemBuilder: (context, index) {
            final text = texts[index];

            return Material(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              color: (category == text) ? color : Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  selectCategoryCallback(text);
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
                          color:
                              (category == text) ? Colors.black : Colors.white),
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
