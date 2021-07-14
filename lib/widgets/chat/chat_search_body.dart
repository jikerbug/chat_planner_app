// import 'package:chat_planner_app/functions/chat_room_enter_function.dart';
// import 'package:chat_planner_app/functions/date_time_function.dart';
// import 'package:chat_planner_app/models/chat_room.dart';
// import 'package:chat_planner_app/models_singleton/user.dart';
// import 'package:chat_planner_app/providers/data.dart';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class ChatSearchBody extends StatefulWidget {
//   final List<ChatRoom> chatRooms;
//
//   ChatSearchBody({
//     required this.chatRooms,
//   });
//
//   @override
//   _ChatSearchBodyState createState() => _ChatSearchBodyState();
// }
//
// class _ChatSearchBodyState extends State<ChatSearchBody> {
//   // bool isSearch = false; 서비스 커지면 검색기능 추가하기
//   bool isEmptySeat = false;
//   bool isNotLocked = false;
//   bool isCountCriteria = false;
//   String text = '';
//   @override
//   Widget build(BuildContext context) {
//     if (widget.chatRooms.length == 0) {
//       return Expanded(
//         child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             ),
//             child: Center(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/heart_flower_2.png',
//                   width: 160,
//                   height: 160,
//                   fit: BoxFit.fill,
//                   color: Colors.black,
//                 ),
//                 Text('새로운 실천채팅방을 추가해주세요'),
//               ],
//             ))),
//       );
//     }
//
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: 16.0,
//                     bottom: 16.0,
//                   ),
//                 ),
//                 // Text(
//                 //   '직접검색',
//                 // ),
//                 // Checkbox(
//                 //     value: isSearch,
//                 //     onChanged: (value) {
//                 //       setState(() {
//                 //         isSearch = value!;
//                 //       });
//                 //     }),
//                 Text(
//                   '빈자리',
//                 ),
//                 Checkbox(
//                     value: isEmptySeat,
//                     onChanged: (value) {
//                       setState(() {
//                         isEmptySeat = value!;
//                       });
//                     }),
//                 Text(
//                   '공개',
//                 ),
//                 Checkbox(
//                     value: isCountCriteria,
//                     onChanged: (value) {
//                       setState(() {
//                         isCountCriteria = value!;
//                       });
//                     }),
//               ],
//             ),
//             // if (isSearch)
//             //   Row(
//             //     children: [
//             //       Expanded(
//             //         child: TextField(
//             //           keyboardType: TextInputType.text,
//             //           onChanged: (text) {},
//             //           decoration: InputDecoration(
//             //               border: InputBorder.none,
//             //               icon: Padding(
//             //                   padding: EdgeInsets.only(left: 13),
//             //                   child: Icon(
//             //                     Icons.search,
//             //                   ))),
//             //         ),
//             //       ),
//             //       TextButton(
//             //         onPressed: () {
//             //           setState(() {
//             //             text = '';
//             //           });
//             //         },
//             //         child: Text('검색'),
//             //       ),
//             //     ],
//             //   ),
//             buildChats(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildChats() => Expanded(
//         child: ListView.builder(
//           physics: BouncingScrollPhysics(),
//           itemBuilder: (context, index) {
//             ChatRoom chatRoom = widget.chatRooms[index];
//
//             return Container(
//               margin: EdgeInsets.only(top: 10.0),
//               child: Material(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10.0),
//                 ),
//                 elevation: 2.0,
//                 child: Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           if (chatRoom.password != '') Icon(Icons.lock),
//                           Text(
//                             chatRoom.chatRoomTitle,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18.0,
//                                 color: Colors.teal),
//                           ),
//                           Text(
//                             '(${chatRoom.currentMemberNum}명/${chatRoom.maxMemberNum}명)',
//                             style: TextStyle(),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '주간 실천 : ',
//                             style: TextStyle(
//                                 fontSize: 13, color: Colors.grey[600]),
//                           ),
//                           Text(
//                             chatRoom.weeklyDoneCount.toString(),
//                             style: TextStyle(fontSize: 13),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '총 실천 : ',
//                             style: TextStyle(
//                                 fontSize: 13, color: Colors.grey[600]),
//                           ),
//                           Text(
//                             chatRoom.totalDoneCount.toString(),
//                             style: TextStyle(fontSize: 13),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '개설자 : ',
//                             style: TextStyle(
//                                 fontSize: 13, color: Colors.grey[600]),
//                           ),
//                           Text(
//                             chatRoom.createUser,
//                             style: TextStyle(fontSize: 13),
//                           ),
//                           Text(
//                             ' 시작일 : ',
//                             style: TextStyle(
//                                 fontSize: 13, color: Colors.grey[600]),
//                           ),
//                           Text(
//                             DateTimeFunction.lastSentTimeFormatter(
//                                 DateTime.parse(chatRoom.createdTime)),
//                             style: TextStyle(fontSize: 13),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         height: 10.0,
//                         color: Colors.grey[600],
//                       ),
//                       if (chatRoom.password != '')
//                         Icon(
//                           Icons.lock,
//                           color: Colors.grey,
//                         ),
//                       if (chatRoom.password == '')
//                         Text(
//                           chatRoom.description,
//                           maxLines: 2, //이렇게 하면 그냥 2줄에서 더 안길어지고 짤린다! 굿!
//                           style: TextStyle(fontSize: 13),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           itemCount: widget.chatRooms.length,
//         ),
//       );
// }
