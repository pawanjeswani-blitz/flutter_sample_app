import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/paginated_salon_response.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:http/http.dart' as http;

class LoadSalons {
  static Future<SuperResponse<PaginatedSalonResponse>> getSalonFeed(
      int pageNo) async {
    final nonLoginAuthToken = await AppSessionManager.getNonLoginAuthToken();
    final body = {
      "authToken":
          "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjcsImxvZ2luSWQiOjE1OCwicGxhdGZvcm0iOiJQaG9uZSIsImlhdCI6MTYwOTAxNDcwMSwiZXhwIjoyNTQyMTM0NzAxfQ._k4UlPg88NkJBYC6rjilbKcyM33r8GuOv3PAHKRSXRk",
      "latUser": 19,
      "longUser": 23
    };
    debugPrint(
        "${Constants.SecondryUrl}${Constants.GetSalonFeedList}${pageNo.toString()}");
    debugPrint(jsonEncode(body));
    return http
        .post(
            "${Constants.SecondryUrl}${Constants.GetSalonFeedList}${pageNo.toString()}",
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(body))
        .then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        throw new Exception("Error while fetching data");
      }

      debugPrint(response.body);
      Map<String, dynamic> map = json.decode(response.body);
      // return SuperResponse.fromJson(map, null);
      return SuperResponse.fromJson(
          map, PaginatedSalonResponse.fromJson(map['data']));
    });
  }
}
