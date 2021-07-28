import 'package:chat_planner_app/api/firestore_cheer_api.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:chat_planner_app/widgets/cheer_tile.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class CheerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO:'CheerList는 RTDB에 메시지 업데이트하고, 확인한 메시지는 없애는 것으로 하자?.. 하지만 범용성떨어짐');
    //TODO: 로컬 메시지를 구현하자는 건데 어차피 결국 가야할 방향은 맞다
    //TODO: 로컬에다가, 마지막에 확인한 메시지를 저장하고, 그 이후의 메시지만 쿼리 요청하면 된다.
    //TODO: 나머지는 로컬행. 응원함은 초기화면에서도 볼 수 있기 때문에 반드시 구현해야한다
    //TODO: !!!!!!!!!!!중요!!!!!!! 동일한 원리로, ChatListScreen에서도
    //TODO: RTDB에 isChatRoomListStateChanged새로 만들고 리스너 달아서 이것이 true일 때만 새 정보 불러오자
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: PaginateFirestore(
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
            Text('실천채팅방에 참가하고 응원을 주고 받아 보세요!'),
          ],
        )),
        reverse: false,
        //item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.listView, //Change types accordingly
        separator: Divider(
          height: 0.5,
          thickness: 0.5,
        ),
        itemBuilder: (index, context, documentSnapshot) {
          Map cheerInfo = documentSnapshot.data() as Map;
          String plan = cheerInfo['plan'];
          String planType = cheerInfo['planType'];
          String type = cheerInfo['type'];
          String senderNickname = cheerInfo['senderNickname'];
          DateTime time = cheerInfo['time'].toDate();

          print(index);

          return CheerTile(
            plan: plan,
            planType: planType,
            type: type,
            senderNickname: senderNickname,
            time: time,
          );
        },
// orderBy is compulsory to enable pagination
        query: FireStoreCheerApi.getCheersQuery(User().userId),
// to fetch real-time data
        isLive: true,
      ),
    );
  }
}
