//habit의 종류
//1. 일반
//2. 기상 - not mvp
//3. 일회성 - not mvp
//4. 서브습관 - not mvp
// 학생들 대상이라면,,,, 동조효과가 좀더 가미되어야 하지 않을까?
// 즉, 습관을 큐레이션 할 수 있는것?....
// 즉, 자신의 습관을 공유하고, 이 게시습관을 통해 하트를 받을 수 있게?
// 그것 이외에도 7시기상, 6시기상 같은 것들에 대해 전체 사용자가 얼마나 해당 습관을
// 채택하고 있는지 보는 것도 좋을 것 같다.

import 'package:chat_planner_app/api_in_local/hive_plan_api.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/functions/date_time_function.dart';
import 'package:chat_planner_app/screens/plan/plan_category_select.dart';
import 'package:chat_planner_app/widgets/circle_border_box.dart';
import 'package:chat_planner_app/widgets/rounded_button.dart';
import 'package:chat_planner_app/widgets/thin_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatAddScreen extends StatefulWidget {
  static String id = 'ChatAddScreen';
  @override
  _ChatAddScreenState createState() => _ChatAddScreenState();
}

class _ChatAddScreenState extends State<ChatAddScreen> {
  String title = '';
  var textEditingController = TextEditingController();

  Widget sameGroupGapBox() => Divider(
        height: 25.0,
        color: Colors.grey[400],
        thickness: 0.1,
      );
  Widget otherGroupGapBox() => SizedBox(
        height: 20.0,
      );

  String category = '선택안함';
  String memberNum = '선택안함';

  Widget inputLineCard(title, hint) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Text(title),
            Expanded(
              child: TextFormField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
                controller: textEditingController,
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: hint, isDense: true),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.4, 0.5],
          colors: [
            Colors.green[300]!,
            Colors.green[700]!,
            Colors.green[800]!,
          ],
        ),
      ),
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      '채팅방 생성',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                inputLineCard('채팅방명', '채팅방 이름을 정해주세요'),
                sameGroupGapBox(),
                inputLineCard('카테고리', '채팅방 카테고리를 정해주세요'),
                sameGroupGapBox(),
                inputLineCard('최대인원', '입장가능한 최대 인원 수를 정해주세요'),
                sameGroupGapBox(),
                inputLineCard('비밀번호', '(선택사항)'),
                sameGroupGapBox(),
                //     items: ['선택안함', '공부', '운동', '독서', '생활습관', '음악/미술', '코딩'],
                //     items: ['선택안함', '5명', '10명', '15명', '20명', '25명', '30명'],
                Row(
                  children: [
                    SizedBox(
                      width: 20.0,
                    ),
                    Text('채팅방 소개'),
                  ],
                ),
                otherGroupGapBox(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    controller: textEditingController,
                    onChanged: (value) {
                      title = value;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: ' 채팅방을 간단하게 소개해주세요',
                        isDense: true),
                  ),
                ),
                otherGroupGapBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoundedButton(
                        minWidth: 100.0,
                        color: Colors.orangeAccent,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: '닫기'),
                    RoundedButton(
                        minWidth: 100.0,
                        color: Colors.teal,
                        onPressed: () {
                          if (title != '') {
                            Navigator.pop(context);
                          }
                        },
                        title: '추가'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
