import 'package:chat_planner_app/api/firestore_api.dart';
import 'package:chat_planner_app/models/chat_room.dart';
import 'package:chat_planner_app/widgets/chat/chat_room_tile.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ChatSearchList extends StatelessWidget {
  ChatSearchList({required this.selectedCategory, required this.criteria});

  final String selectedCategory;
  final String criteria;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: Key(selectedCategory),
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
          itemsPerPage: 2,
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

            print(index);

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
              category: chatInfo['category'],
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
}
