import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APICall {
  //API URL
  static const String baseUrl =
      "https://beaw.intactitinfo.com/api/APICustomer/";

  static Future<Response> post(String endPoint, data) async {
    Dio dio = Dio();
//    print(data);
    Response response =
        await dio.post(baseUrl + endPoint, queryParameters: data);
    return response;
  }

  static Future<Response?> get(String endPoint, data) async {
    Dio dio = Dio();
    try {
      Response response = await dio
          .get(baseUrl + endPoint, queryParameters: data)
          .catchError((e) => print(e.response));
      return response;
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
