import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/models/chat_room.dart';

import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'chat_room_tile.dart';

class ChatSearchBody extends StatefulWidget {
  final String selectedCategory;
  final String criteria;

  ChatSearchBody({
    required this.selectedCategory,
    required this.criteria,
  });

  @override
  _ChatSearchBodyState createState() => _ChatSearchBodyState();
}

class _ChatSearchBodyState extends State<ChatSearchBody> {
  // bool isSearch = false; 서비스 커지면 검색기능 추가하기 algoria
  bool isEmptySeat = false;
  bool isNotLocked = false;
  bool isCountCriteria = false;
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(
            //         top: 16.0,
            //         bottom: 16.0,
            //       ),
            //     ),
            //     Text(
            //       '빈자리',
            //     ),
            //     Checkbox(
            //         value: isEmptySeat,
            //         onChanged: (value) {
            //           setState(() {
            //             isEmptySeat = value!;
            //           });
            //         }),
            //     Text(
            //       '공개',
            //     ),
            //     Checkbox(
            //         value: isCountCriteria,
            //         onChanged: (value) {
            //           setState(() {
            //             isCountCriteria = value!;
            //           });
            //         }),
            //   ],
            // ),
            buildChats(widget.selectedCategory, widget.criteria, context),
          ],
        ),
      ),
    );
  }
}

Widget buildChats(selectedCategory, criteria, context) {
  return Expanded(
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: PaginateFirestore(
        key: Key(selectedCategory),
        physics: BouncingScrollPhysics(),
        itemsPerPage: 1,
        shrinkWrap: true,

        emptyDisplay: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/heart_flower_2.png',
              width: 160,
              height: 160,
              fit: BoxFit.fill,
              color: Colors.black,
            ),
            Text('새로운 실천채팅방을 개설해주세요'),
          ],
        )),
        reverse: false,
        //item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.listView, //Change types accordingly
        itemBuilder: (index, context, documentSnapshot) {
          Map chatInfo = documentSnapshot.data() as Map;
          String chatRoomId = documentSnapshot.id;

          return ChatRoomTile(ChatRoom(
            chatRoomId: chatRoomId,
            chatRoomTitle: chatInfo['chatRoomTitle'],
            weeklyDoneCount: chatInfo['weeklyDoneCount'],
            totalDoneCount: chatInfo['totalDoneCount'],
            createdTime: chatInfo['createdTime'].toDate().toString(),
            createUser: chatInfo['createUser'],
            description: chatInfo['description'],
            currentMemberNum: chatInfo['memberList'].length,
            maxMemberNum: int.parse(chatInfo['maxMemberNum'].split('명')[0]),
            password: chatInfo['password'],
          ));
        },
// orderBy is compulsory to enable pagination
        query: FireStoreApi.getChatRoomsQuery(selectedCategory, criteria),
// to fetch real-time data
        isLive: true,
      ),
    ),
  );
}
