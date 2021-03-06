import 'package:flutter/material.dart';

class CustomDialogFunction {
  static void dialog(
      {required BuildContext context,
      required bool isTwoButton,
      required bool isLeftAlign,
      required Function onPressed,
      required String title,
      required String text,
      required String size}) {
    double height;
    if (size == 'max') {
      height = 350.0;
    } else if (size == 'big') {
      height = 180.0;
    } else if (size == 'middle') {
      height = 100.0;
    } else if (size == 'small') {
      height = 60.0;
    } else {
      height = 60.0;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Container(
                  height: height,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Text(
                    text,
                    textAlign: isLeftAlign ? TextAlign.start : TextAlign.center,
                  ))),
              actions: isTwoButton
                  ? [
                      TextButton(
                        child: Text(
                          "취소",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "확인",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          onPressed();
                          Navigator.pop(context);
                        },
                      ),
                    ]
                  : [
                      TextButton(
                        child: Text(
                          "확인",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  static void dayOfWeekNotSelected(context) {
    dialog(
        context: context,
        isTwoButton: false,
        isLeftAlign: false,
        onPressed: () {},
        title: '요일 선택',
        text: '습관을 실천할 요일을 선택해 주세요',
        size: 'small');
  }

  static void selectChatSettingDialog(context, type, onPressed) {
    late List<String> texts;
    if (type == 'category') {
      texts = ['공부', '운동', '독서', '생활습관', '커스텀'];
    } else if (type == 'maxNum') {
      texts = ['2명', '5명', '10명', '15명', '20명', '25명', '30명'];
    }
    String title = (type == 'category') ? '카테고리' : '최대 인원';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Container(
                height: 350,
                width: MediaQuery.of(context).size.width * 2 / 3,
                alignment: Alignment.center,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onPressed(texts[index]);
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        title: Text(texts[index]),
                      ),
                    );
                  },
                  itemCount: texts.length,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
