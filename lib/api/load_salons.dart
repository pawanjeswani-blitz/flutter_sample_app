import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/paginated_salon_response.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:http/http.dart' as http;

class LoadSalons {
  static Future<SuperResponse<PaginatedSalonResponse>> getSalonFeed(
      int pageNo) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "latUser": 19, "longUser": 23};
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

  static Future<SuperResponse<SaloonServices>> getService(int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "salonId": salonId};
    return http
        .post(
            "http://staging.saloonwala.in/consumercloudspa/api/rs/v1/service/get/consumer/services",
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(body))
        .then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);
      return SuperResponse.fromJson(map, SaloonServices.fromJson(map['data']));
    });
  }

  static Future<SuperResponse<PaginatedSalonResponse>> getSalonSearchFeed(
      int pageNo, String name) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "name": name};
    debugPrint(
        "${Constants.SecondryUrl}${Constants.GetSearchList}${pageNo.toString()}");
    debugPrint(jsonEncode(body));
    return http
        .post(
            "${Constants.SecondryUrl}${Constants.GetSearchList}${pageNo.toString()}",
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
