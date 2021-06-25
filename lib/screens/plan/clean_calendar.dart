// import 'package:flutter/material.dart';
// import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
//
// class PlanRecordScreen extends StatefulWidget {
//   static String id = 'plan_record_screen';
//   @override
//   _PlanRecordScreenState createState() => _PlanRecordScreenState();
// }
//
// class _PlanRecordScreenState extends State<PlanRecordScreen> {
//   DateTime selectedDay = DateTime.now();
//   late List selectedEvent;
//
//   final Map<DateTime, List<CleanCalendarEvent>> events = {
//     DateTime(2021, 6, 12): [
//       CleanCalendarEvent(
//         '밥먹기',
//         startTime: DateTime.now(),
//         endTime: DateTime.now(),
//         color: Colors.teal,
//         description: '와우,,,,',
//         isDone: true,
//       ),
//       CleanCalendarEvent('밥먹기',
//           startTime: DateTime.now(),
//           endTime: DateTime.now(),
//           color: Colors.teal,
//           description: '와우,,,,',
//           isAllDay: false),
//     ],
//     DateTime(2021, 6, 22): [
//       CleanCalendarEvent('걷기',
//           startTime: DateTime.now(), endTime: DateTime.now())
//     ],
//   };
//
//   void _handleData(date) {
//     setState(() {
//       selectedDay = date;
//       selectedEvent = events[selectedDay] ?? [];
//     });
//     print(selectedDay);
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     selectedEvent = events[selectedDay] ?? [];
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.5,
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: SafeArea(
//         child: Container(
//           child: Calendar(
//             locale: 'ko-KR',
//             onEventSelected: (value) => Container(
//               child: Text(value.toString()),
//             ),
//             hideTodayIcon: true,
//             startOnMonday: true,
//             selectedColor: Colors.teal,
//             todayColor: Colors.red,
//             eventColor: Colors.teal,
//             eventDoneColor: Colors.amber,
//             bottomBarColor: Colors.deepOrange,
//             onRangeSelected: (range) {
//               print('Selected Day ${range.from}, ${range.to}');
//             },
//             events: events,
//             isExpanded: true,
//             dayOfWeekStyle: TextStyle(
//               fontSize: 13,
//               color: Colors.black,
//               fontWeight: FontWeight.w900,
//             ),
//             bottomBarTextStyle: TextStyle(
//               color: Colors.white,
//             ),
//             hideBottomBar: false,
//             isExpandable: true,
//             hideArrows: false,
//             weekDays: ['월', '화', '수', '목', '금', '토', '일'],
//           ),
//         ),
//       ),
//     );
//   }
// }
