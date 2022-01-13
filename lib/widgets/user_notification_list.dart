import 'package:flutter/material.dart';
import 'package:qrcode/model/notify.dart';
import 'package:qrcode/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UserNotifcationList extends StatefulWidget {
  Datum? list;
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
        trailing: widget.list!.url!.isEmpty
            ? Text('')
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: StadiumBorder(),
                ),
                child: Text(
                  "Open Link",
                  style: TextStyle(
                      letterSpacing: 1, fontSize: 14, color: Colors.black),
                ),
                onPressed: () async {
                  print(widget.list!.url!);
                  if (!await launch(widget.list!.url!))
                    throw 'Could not launch $widget.list!.url!';
                },
              ),
      ),
    );
  }
}
