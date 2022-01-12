import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qrcode/model/notify.dart';
import 'package:qrcode/services/api.dart';
import 'package:qrcode/utils/app_colors.dart';
import 'package:qrcode/widgets/user_notification_list.dart';

class UserNotification extends StatefulWidget {
  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  NotificationData? notificationData;
  bool loading = false;
  String? qridcode;

  getData() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    qridcode = await storage.read(key: 'qridcode');

    Response? response = await APICall.get('GetNotificationByCustomer', {
      'Qrid': qridcode,
    });

    if (response != null) {
//      print(response.data);
      if (response.data["IsStatus"]) {
        print(response.data);
        setState(() {
          // notificationData = null;
          notificationData = NotificationData.fromJson(response.data["Data"]);

          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Notifications",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: AppColors.primaryColor),
              ),
              TextButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Response response =
                        await APICall.post("ClearNotification", {
                      "QrId": qridcode,
                    });
                    print(response.data);
                    getData();
                  }),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : notificationData == null || notificationData!.data!.isEmpty
                    ? Center(
                        child: Text(
                          'No Notification to show',
                          style: TextStyle(color: Colors.white60, fontSize: 18),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => getData(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: notificationData?.data?.length,
                          itemBuilder: (ctx, index) {
                            return UserNotifcationList(
                                notificationData?.data?[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
