import 'package:chat_planner_app/providers/data.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SideNav extends StatefulWidget {
  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  String nickname = '지백';
  String birthday = '1998-03-26';
  int age = 24;
  String profileImageUrl = '';
  void changeNicknameInSideNavCallback(value) {
    setState(() {
      nickname = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data providerData = Provider.of<Data>(context, listen: false);
    Map userInfo = providerData.userInfo;
    //profileImageUrl = providerData.profileImageUrl;

    //nickname = userInfo['nickname'];
    //birthday = userInfo['birthday'];
    //age = UtilFunctions.birthdayToAge(birthday);

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.4, 0.8],
              colors: [
                Colors.green[300]!,
                Colors.green[700]!,
                Colors.green[800]!,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (profileImageUrl != 'no_profile_image') ...[
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 40.0,
                      backgroundImage: NetworkImage(profileImageUrl)),
                ] else ...[
                  CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 40.0,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.white,
                      )),
                ],
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nickname',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      '$age살',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(
            Icons.perm_identity_outlined,
          ),
          title: Text('프로필 수정'),
        ),
        ListTile(
          leading: Icon(
            Icons.storefront,
          ),
          title: Text('상점'),
        ),
        Divider(color: Colors.black54),
        ListTile(
          leading: Icon(
            Icons.settings,
          ),
          title: Text('설정'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(
            Icons.help_outline,
          ),
          title: Text('도움말'),
        ),
        Divider(color: Colors.black54),
        ListTile(
          leading: Icon(
            Icons.logout,
          ),
          title: Text('로그아웃'),
          onTap: () {},
        ),
      ],
    );
  }
}
