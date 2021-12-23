import 'package:flutter/material.dart';
import 'package:qrcode/model/notify.dart';
import 'package:qrcode/utils/app_colors.dart';

class UserNotifcationList extends StatefulWidget {
  final Datum? list;
  UserNotifcationList(this.list);
  @override
  _UserNotifcationListState createState() => _UserNotifcationListState();
}

class _UserNotifcationListState extends State<UserNotifcationList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Colors.white, AppColors.primaryColor], radius: 2.8),
          borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(10),
      child: ListTile(
//        leading: Text(
//          widget.list!.notificationDate!,
//          style: TextStyle(color: Colors.white),
//        ),
        title: Text(
          widget.list!.title!,
          // style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          widget.list!.message!,
        ),
      ),
    );
  }
}
