import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:qrcode/screens/nav_pages/bottom_navigation.dart';
import 'package:qrcode/services/api.dart';
import 'package:qrcode/utils/app_colors.dart';
import 'package:qrcode/widgets/custom_textfield.dart';
import 'package:qrcode/widgets/loading_diolog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showCurrent = false, showNew = false;

  login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      BuildContext? loadContext;
      print('login');
      showDialog(
          context: context,
          builder: (ctx) {
            loadContext = ctx;
            return LoadingDialog();
          },
          barrierDismissible: false);
      Response? response = await APICall.get("CustomerLogin", {
        "UserName": username,
        "Password": password,
      });
      print(response?.data);
      if (response?.data["IsStatus"]) {
        String qridcode = response?.data["Data"][0]["QRIDCode"];
        FlutterSecureStorage storage = FlutterSecureStorage();
        await storage.write(key: "username", value: username);
        if (response?.data["Data"][0]["IsPwdUpd"] == 1) {
          await storage.write(
              key: "qridcode", value: response?.data["Data"][0]["QRIDCode"]);
        }
        await storage.write(
            key: "ispwdupd",
            value: response?.data["Data"][0]["IsPwdUpd"].toString());
        if (response?.data["Data"][0]["IsPwdUpd"] == 0) {
          Navigator.pop(loadContext!);
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (ctx) {
                TextEditingController newPass = TextEditingController();
                bool showNew = false, showConfirm = false;
                final key = GlobalKey<FormState>();
                return AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.all(0.0),
                  content: StatefulBuilder(builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            colors: [Colors.white, AppColors.primaryColor],
                            radius: 2.8),
                      ),
                      child: Form(
                        key: key,
                        child: Column(
                          children: [
                            Text(
                              "Change Password",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                      await APICall.post("changepassword", {
                                    "QrId": qridcode,
                                    "Password": newPass.text,
                                  });
                                  print(response.data);
                                  if (response.data['IsStatus']) {
                                    await storage.write(
                                      key: "qridcode",
                                      value: qridcode,
                                    );
                                    Fluttertoast.showToast(
                                        msg: response.data['Message']);
                                    response = await APICall.post(
                                        "AddMobileAppToken", {
                                      "Qrid": qridcode,
                                      "TokenNo": await FirebaseMessaging
                                          .instance
                                          .getToken(),
                                    });
                                    print(response.data);
                                  }
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => BottomNavigation()));
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
        } else {
          Fluttertoast.showToast(msg: "Login Successful");
//          Clipboard.setData(
//              ClipboardData(text: await FirebaseMessaging.instance.getToken()));
          debugPrint(await FirebaseMessaging.instance.getToken());
          Response? response = await APICall.post("AddMobileAppToken", {
            "Qrid": qridcode,
            "TokenNo": await FirebaseMessaging.instance.getToken(),
          });

          Navigator.pop(loadContext!);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => BottomNavigation()));
        }
      } else {
        Fluttertoast.showToast(msg: response?.data["Message"]);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "LOGIN",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _usernameController,
                  labelText: "Username",
                  prefixIcon: Icon(
                    Icons.supervised_user_circle,
                    color: AppColors.primaryColor,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) return 'Enter Username';
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.primaryColor,
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Enter Password';
                      return null;
                    },
                    obscureText: !showCurrent,
                    suffixIcon: GestureDetector(
                      child: Icon(showCurrent
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onTap: () {
                        setState(() {
                          showCurrent = !showCurrent;
                        });
                      },
                    )),
                TextButton(
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
//                  onPressed: forgotPassword,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          TextEditingController fgtusername =
                              TextEditingController();
                          final key = GlobalKey<FormState>();
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
                                        controller: fgtusername,
                                        decoration: InputDecoration(
                                          hintText: "Username",
                                        ),
                                        validator: (val) {
                                          return val!.isEmpty
                                              ? "Enter Username"
                                              : null;
                                        },
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
                                            Response? response =
                                                await APICall.get(
                                                    "Forgotpassword", {
                                              "UserName": fgtusername.text,
                                            });
//                                            print(response?.data);
                                            if (response?.data['IsStatus']) {
                                              Fluttertoast.showToast(
                                                  msg: response
                                                      ?.data['Message']);
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
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: StadiumBorder()),
//                    onPressed: () {
//                      Navigator.of(context).pushReplacement(MaterialPageRoute(
//                          builder: (_) => BottomNavigation()));
//                    },
                    onPressed: login,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          letterSpacing: 2, fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
