// import 'package:chat_planner_app/functions/custom_dialog_function.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
//
// class SearchPanel extends StatefulWidget {
//   SearchPanel();
//
//   @override
//   _SearchPanelState createState() => _SearchPanelState();
// }
//
// class _SearchPanelState extends State<SearchPanel> {
//   bool isNew = false;
//   bool isEmptySeat = false;
//   bool isWakeMission = false;
//   bool isCountCriteria = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isRewardDisplaySetting = true;
//     String searchType = '최근실천';
//
//     return Container(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: 16.0,
//                   bottom: 16.0,
//                 ),
//               ),
//               Text(
//                 '최근실천',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Checkbox(
//                   value: isNew,
//                   onChanged: (value) {
//                     setState(() {
//                       isNew = value!;
//                     });
//                   }),
//               Text(
//                 '신규',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Checkbox(
//                   value: isEmptySeat,
//                   onChanged: (value) {
//                     setState(() {
//                       isEmptySeat = value!;
//                     });
//                   }),
//               Text(
//                 '총 실천횟수',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Checkbox(
//                   value: isCountCriteria,
//                   onChanged: (value) {
//                     setState(() {
//                       isCountCriteria = value!;
//                     });
//                   }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
