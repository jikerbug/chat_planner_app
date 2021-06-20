import 'package:flutter/material.dart';

class ProfileViewScreen extends StatefulWidget {
  static const String id = 'profile_view_screen';

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late String profileUrl;
  late Map userInfo;

  @override
  Widget build(BuildContext context) {
    userInfo = ModalRoute.of(context)!.settings.arguments as Map;
    profileUrl = userInfo["profileUrl"];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text(
            '사진',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: (profileUrl != 'no_profile_image')
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(profileUrl),
                    fit: BoxFit.contain,
                  ),
                  shape: BoxShape.rectangle,
                ),
              )
            : Container(
                child: Center(child: Text('사진이 없습니다.')),
              ));
  }
}
