// import 'package:chat_planner_app/models/chat_room.dart';
// import 'package:chat_planner_app/models_singleton/user.dart';
// import 'package:chat_planner_app/widgets/chat/chat_list_header.dart';
// import 'package:chat_planner_app/widgets/chat/chat_search_body.dart';
// import 'package:chat_planner_app/widgets/chat/search_panel.dart';
// import 'package:flutter/material.dart';
//
// class ChatSearchScreen extends StatefulWidget {
//   static const String id = 'chat_search_screen';
//
//   @override
//   _ChatSearchScreenState createState() => _ChatSearchScreenState();
// }
//
// class _ChatSearchScreenState extends State<ChatSearchScreen> {
//   final List<String> texts = ['전체', '공부', '운동', '독서', '생활습관', '음악/미술', '코딩'];
//
//   @override
//   Widget build(BuildContext context) {
//     final List<ChatRoom> chatRooms = [
//       ChatRoom(
//         serverId: User().userId,
//         lastMessageTime: DateTime.now(),
//         name: "기상인증 모여라",
//       ),
//       ChatRoom(
//         serverId: 'test_friend',
//         lastMessageTime: DateTime.now(),
//         name: "친구방",
//       ),
//     ];
//
//     final tab = TabBar(tabs: <Tab>[
//       Tab(icon: Text('최근실천')),
//       Tab(icon: Text('신규')),
//       Tab(icon: Text('총 실천횟수')),
//     ]);
//
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: tab.preferredSize,
//           child: Card(
//             margin: EdgeInsets.all(0),
//             color: Colors.green,
//             child: tab,
//           ),
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               stops: [0.1, 0.4, 0.5],
//               colors: [
//                 Colors.green[300]!,
//                 Colors.green[700]!,
//                 Colors.green[800]!,
//               ],
//             ),
//           ),
//           child: SafeArea(
//               child: Column(
//                 children: [
//                   ChatListHeader(texts: texts),
//                   ChatSearchBody(chatRooms: chatRooms),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
