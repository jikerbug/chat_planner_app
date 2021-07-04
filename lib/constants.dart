import 'package:flutter/material.dart';

double kAppbarLeftMargin(context) {
  return MediaQuery.of(context).size.width / 20;
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.green,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    hintText: '응원의 메세지를 보내주세요!',
    border: InputBorder.none,
    fillColor: Colors.teal);

const kMessageContainerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border(
    top: BorderSide(color: Colors.green, width: 2.0),
  ),
);

const kInputDecoration = InputDecoration(
  hintText: 'Enter your value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const String kTodoRecordBoxName = 'todoRecord';
