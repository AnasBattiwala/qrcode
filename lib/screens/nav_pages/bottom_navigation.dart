import 'package:flutter/material.dart';
import 'package:qrcode/utils/app_colors.dart';
import 'home.dart';
import 'profile.dart';
import 'user_notification.dart';
//import 'package:flutter/foundation.dart' show TargetPlatform;
import 'dart:io' show TargetPlatform;

class BottomNavigation extends StatefulWidget {
  int index;

  BottomNavigation({this.index = 0});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final _pages = [Home(), UserNotification(), Profile()];
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
//      onWillPop: ,
      onWillPop: () async {
        bool? toPop = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    backgroundColor: AppColors.primaryColor,
                    title: Text('Are you sure you want to quit?'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('Yes'),
                          onPressed: () => Navigator.of(context).pop(true)),
                      FlatButton(
                          child: Text('No'),
                          onPressed: () => Navigator.of(context).pop(false)),
                    ]));
        return toPop ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          unselectedIconTheme: IconThemeData(color: Colors.white60),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_sharp), label: ""),
          ],
        ),
      ),
    );
  }
}
