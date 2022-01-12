// To parse this JSON data, do
//
//     final notificationData = notificationDataFromJson(jsonString);

import 'dart:convert';

NotificationData notificationDataFromJson(String str) =>
    NotificationData.fromJson(json.decode(str));

String notificationDataToJson(NotificationData data) =>
    json.encode(data.toJson());

class NotificationData {
  NotificationData({
//    this.isStatus,
//    this.message,
    this.data,
  });

//  bool? isStatus;
//  String? message;
  List<Datum>? data;

  factory NotificationData.fromJson(json) => NotificationData(
        data: List<Datum>.from(json.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.notificationDate,
    this.title,
    this.message,
    this.qrid,
    this.appToken,
    this.url,
  });

  DateTime? notificationDate;
  String? title;
  String? message;
  String? qrid;
  String? appToken;
  String? url;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        notificationDate: DateTime.parse(json["NotificationDate"]),
        title: json["Title"],
        message: json["Message"],
        qrid: json["QRID"],
        appToken: json["AppToken"],
        url: json["NotiURL"],
      );

  Map<String, dynamic> toJson() => {
        "NotificationDate": notificationDate?.toIso8601String(),
        "Title": title,
        "Message": message,
        "QRID": qrid,
        "AppToken": appToken,
        "NotiURL": url,
      };
}
