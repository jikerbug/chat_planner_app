// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:async';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:chat_planner_app/widgets/rounded_button.dart';
// import 'package:chat_planner_app/models_singleton/user.dart';
//
// //https://www.youtube.com/watch?v=HCmAwk2fnZc 해당링크를 상당 참조함(파일자르기, 불러오기 관련)
// //https://www.youtube.com/watch?v=pvRpzyBYBbA 여기두(업로드 관련)
//
// class ImageScreen extends StatefulWidget {
//   static const String id = 'image_screen';
//
//   @override
//   _ImageScreenState createState() => _ImageScreenState();
// }
//
// class _ImageScreenState extends State<ImageScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   File? imageFile;
//   final ImagePicker picker = ImagePicker();
//
//   Future<void> pickImage(ImageSource source) async {
//     PickedFile? selected = await picker.getImage(
//         source: source, maxHeight: 960, maxWidth: 960); //max...로 최대 해상도를 조절가능!
//
//     setState(() {
//       if (selected != null) {
//         imageFile = File(selected.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<void> cropImage() async {
//     File? cropped = await ImageCropper.cropImage(sourcePath: imageFile!.path);
//
//     setState(() {
//       imageFile = cropped ?? imageFile;
//     });
//   }
//
//   void clear() {
//     setState(() {
//       imageFile = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('사진'),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Padding(
//           padding: EdgeInsets.all(12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.photo_camera,
//                   size: 35.0,
//                 ),
//                 onPressed: () {
//                   pickImage(ImageSource.camera);
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.photo_library,
//                   size: 35.0,
//                 ),
//                 onPressed: () {
//                   pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: (imageFile != null)
//           ? Column(
//               children: [
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height / 2,
//                   child: Image.file(
//                     imageFile!,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     RoundedButton(
//                       minWidth: 100.0,
//                       title: '편집',
//                       color: Colors.teal,
//                       onPressed: cropImage,
//                     ),
//                     SizedBox(
//                       width: 10.0,
//                     ),
//                     RoundedButton(
//                       minWidth: 100.0,
//                       title: '지우기',
//                       color: Colors.orange,
//                       onPressed: clear,
//                     )
//                   ],
//                 ),
//                 Uploader(
//                   file: imageFile!,
//                   userId: ,
//                 ),
//               ],
//             )
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: (arguments["profileImageUrl"] == "no_profile_image")
//                     ? [
//                         Text(
//                           '사진을 추가해주세요',
//                           style: TextStyle(fontSize: 24.0),
//                         ),
//                       ]
//                     : [
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image:
//                                     NetworkImage(arguments["profileImageUrl"]),
//                                 fit: BoxFit.contain,
//                               ),
//                               shape: BoxShape.rectangle,
//                             ),
//                           ),
//                         ),
//                         RoundedButton(
//                           minWidth: 100.0,
//                           title: '기본 이미지로 변경',
//                           color: Colors.green,
//                           onPressed: () {
//                             FirebaseStorage.instance
//                                 .ref()
//                                 .child('profileImage')
//                                 .child()
//                                 .delete();
//
//                             Function setStateForChangeProfileImage =
//
//                             ["callback"];
//                             setStateForChangeProfileImage('no_profile_image');
//
//                             Navigator.pop(context);
//                           },
//                         ),
//                         SizedBox(height: 20)
//                       ],
//               ),
//             ),
//     );
//   }
// }
//
// class Uploader extends StatefulWidget {
//   final File file;
//   final userId;
//   Uploader({required this.file, this.userId});
//
//   @override
//   _UploaderState createState() => _UploaderState();
// }
//
// class _UploaderState extends State<Uploader> {
//   final _storage = FirebaseStorage.instance;
//   Future<String> uploadImage() async {
//     if (widget.file != null) {
//       await _storage
//           .ref()
//           .child('profileImage/${widget.userId}')
//           .putFile(widget.file);
//
//       return await FirebaseStorage.instance
//           .ref()
//           .child('profileImage')
//           .child(widget.userId)
//           .getDownloadURL();
//     }
//     return 'no_profile_image';
//   }
//
//   bool isUploading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return !isUploading
//         ? Container(
//             width: 210.0,
//             child: RoundedButton(
//               minWidth: 100.0,
//               title: '프로필 설정',
//               color: Colors.green,
//               onPressed: () async {
//                 setState(() {
//                   isUploading = true;
//                 });
//                 String url = await uploadImage();
//                 if (url != 'no_profile_image') {}
//
//                 setState(() {
//                   isUploading = false;
//                 });
//
//                 Navigator.pop(context);
//               },
//             ))
//         : Column(
//             children: [
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                   width: 30.0,
//                   height: 30.0,
//                   child: Center(child: CircularProgressIndicator())),
//             ],
//           );
//   }
// }
