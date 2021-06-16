// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(
//           Icons.add,
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: ValueListenableBuilder(
//             valueListenable: Hive.box<WordModel>('word').listenable(),
//             builder: (context, Box<WordModel> box, child) {
//               return ListView.separated(
//                 itemBuilder: (_, index) {
//                   final item = box.getAt(index);
//
//                   if (item == null) {
//                     return Container(
//                       child: Text('아이템이 존재하지 않습니다.'),
//                     );
//                   } else {
//                     return Container(
//                       child: Text('asd'),
//                     );
//                   }
//                 },
//                 separatorBuilder: (_, index) {
//                   return Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Divider(),
//                   );
//                 },
//                 itemCount: box.length,
//               );
//             }),
//       ),
//     );
//   }
// }
