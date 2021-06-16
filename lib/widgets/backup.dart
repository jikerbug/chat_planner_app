// import 'package:chat_planner_app/api/firebase_plan_api.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class PlanTile extends StatefulWidget {
//   final bool isChecked;
//   final String title;
//   final int index;
//   final String timestamp;
//   final String userId;
//
//   final Key key;
//
//   PlanTile({
//     required this.key,
//     required this.userId,
//     required this.isChecked,
//     required this.title,
//     required this.index,
//     required this.timestamp,
//   });
//
//   @override
//   _PlanTileState createState() => _PlanTileState();
// }
//
// class _PlanTileState extends State<PlanTile> {
//   void taskDone(providerData, value) async {
//     final chatRoomId = providerData.chatRoomId;
//     final friendUserId = providerData.friendUserId;
//
//     FirebasePlanApi.toggleCheckBox(
//         widget.userId, widget.timestamp, value, friendUserId, chatRoomId);
//   }
//
//   Widget deleteTaskBackGround() {
//     return Container(
//       decoration: new BoxDecoration(
//           color: Colors.red,
//           borderRadius: new BorderRadius.all(Radius.circular(10.0))),
//       alignment: Alignment.centerRight,
//       padding: EdgeInsets.only(right: 20.0),
//       child: Icon(Icons.delete, color: Colors.white),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final providerData = Provider.of<Data>(context, listen: false);
//
//     return Padding(
//       key: widget.key,
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Dismissible(
//         key: Key(widget.timestamp),
//         onDismissed: (direction) {
//           print(direction);
//           // 해당 index의 item을 리스트에서 삭제
//           providerData.delete(widget.index);
//           FirebasePlanApi.deleteTask(widget.userId, widget.timestamp);
//         },
//         background: deleteTaskBackGround(),
//         child: Material(
//           elevation: 4.0,
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//           child: ListTile(
//             leading: widget.isChecked
//                 ? GestureDetector(
//                     child: widget.index == 1
//                         ? Icon(Icons.check)
//                         : Icon(Icons.refresh),
//                     onTap: () {})
//                 : GestureDetector(
//                     child: GestureDetector(
//                       child: Icon(Icons.photo_camera),
//                       onTap: () {
//                         print('start timer');
//                       },
//                     ),
//                     onTap: () {
//                       print('start timer');
//                     },
//                   ),
//             title: widget.isChecked == false
//                 ? Wrap(
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     children: [
//                         Text(
//                           widget.title,
//                           style: TextStyle(
//                               decoration: widget.isChecked
//                                   ? TextDecoration.lineThrough
//                                   : null),
//                         ),
//                         if (widget.index == 0) ...[
//                           GestureDetector(
//                             child: Icon(
//                               Icons.play_circle_outline,
//                               color: Colors.grey,
//                             ),
//                             onTap: () {
//                               print('start timer2');
//                               ;
//                             },
//                           ),
//                         ] else ...[
//                           GestureDetector(
//                             child: Icon(
//                               Icons.pause_circle_outline,
//                               color: Colors.grey,
//                             ),
//                             onTap: () {
//                               print('start timer2');
//                             },
//                           ),
//                         ],
//                       ])
//                 : Text(
//                     widget.title,
//                     style: TextStyle(
//                         decoration: widget.isChecked
//                             ? TextDecoration.lineThrough
//                             : null),
//                   ),
//             trailing: Checkbox(
//               activeColor: Colors.green,
//               value: widget.isChecked,
//               onChanged: (value) {
//                 if (value == true) {
//                   providerData.toggleCheckBox(widget.index);
//
//                   taskDone(providerData, value);
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
