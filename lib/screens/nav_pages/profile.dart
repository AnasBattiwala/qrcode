import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrcode/screens/auth/login.dart';
import 'package:qrcode/services/api.dart';
import 'package:qrcode/utils/app_colors.dart';
import 'package:qrcode/widgets/custom_textfield.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? mobileController;
  TextEditingController? passwordController;
  TextEditingController? _nameController;
  String? qridcode;

  displayUserProfile() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    qridcode = await storage.read(key: 'qridcode');
    Response? response = await APICall.get("GetCustomerById", {
      "Qrid": qridcode,
    });
//    print(response?.data);
    String name = response?.data["Data"][0]['CustomerName'];
    String mobile = response?.data["Data"][0]['MobileNo'];

    setState(() {
      _nameController = TextEditingController(text: name);
      mobileController = TextEditingController(text: mobile);
    });
  }

  @override
  void initState() {
    super.initState();
    displayUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 15, left: 15, right: 15),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: AppColors.primaryColor),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: CustomTextField(
                    controller: _nameController,
                    labelText: "Name",
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: CustomTextField(
                    controller: mobileController,
                    labelText: "Mobile No",
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      shape: StadiumBorder()),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          TextEditingController newPass =
                              TextEditingController();
                          final key = GlobalKey<FormState>();
                          bool showNew = false, showConfirm = false;
                          return AlertDialog(
                            scrollable: true,
                            contentPadding: EdgeInsets.all(0.0),
                            content: StatefulBuilder(builder: (context, state) {
                              return Container(
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(colors: [
                                    Colors.white,
                                    AppColors.primaryColor
                                  ], radius: 2.8),
                                ),
                                child: Form(
                                  key: key,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Change Password",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        controller: newPass,
                                        decoration: InputDecoration(
                                          hintText: "New Password",
                                          suffixIcon: GestureDetector(
                                            child: Icon(showNew
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onTap: () {
                                              state(() {
                                                showNew = !showNew;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (val) {
                                          return val!.isEmpty
                                              ? "Enter New Password"
                                              : null;
                                        },
                                        obscureText: !showNew,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Confirm Password",
                                        ),
                                        validator: (val) {
                                          return val!.isEmpty
                                              ? "Enter Confirm Password"
                                              : val != newPass.text
                                                  ? "Passwords do not match"
                                                  : null;
                                        },
                                        obscureText: !showConfirm,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () async {
                                          if (key.currentState!.validate()) {
                                            Response response =
                                                await APICall.post(
                                                    "changepassword", {
                                              "QrId": qridcode,
                                              "Password": newPass.text,
                                            });
                                            print(response.data);
                                            if (response.data['IsStatus']) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      response.data['Message']);
                                            }
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        });
                  },
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                        letterSpacing: 2, fontSize: 14, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            backgroundColor: AppColors.primaryColor,
                            title: Text('Are you sure want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('No',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                onPressed: () async {
                                  FlutterSecureStorage storage =
                                      FlutterSecureStorage();
                                  await storage.deleteAll();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (_) => Login()),
                                      (route) => false);
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
