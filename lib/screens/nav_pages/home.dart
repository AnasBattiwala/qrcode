import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/services/api.dart';
import 'package:dio/dio.dart';
import 'package:qrcode/utils/app_colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = new FlutterSecureStorage();
  String? qridcode, name, mobileno, email;

  assignqrcodevalue() async {
    qridcode = await storage.read(key: 'qridcode');
    print(qridcode);
    Response? response = await APICall.get("GetCustomerById", {
      "Qrid": qridcode,
    });
    print(response?.data);
    name = response?.data["Data"][0]['CustomerName'];
    mobileno = response?.data["Data"][0]['MobileNo'];
    email = response?.data["Data"][0]['EmailId'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    assignqrcodevalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          name != null
              ? Text(
                  name!,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      letterSpacing: 3),
                )
              : Text(''),
          SizedBox(
            height: 15,
          ),
          Text(
            "Show QR code in shop to add appointment.",
            style: TextStyle(color: AppColors.primaryColor, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: qridcode == null
                ? Container()
                : QrImage(
                    data: qridcode! + '10',
//            version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
          ),
          SizedBox(
            height: 15,
          ),
//          Text(
//            "Scan this code.",
//            style: TextStyle(
//                color: AppColors.primaryColor, fontSize: 16, letterSpacing: 3),
//          ),
          email != null
              ? Text(
                  email!,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      letterSpacing: 3),
                )
              : Text(''),
          mobileno != null
              ? Text(
                  mobileno!,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      letterSpacing: 3),
                )
              : Text(''),
        ],
      ),
    );
  }
}
