import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/paginated_salon_response.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class LoadSalons {
  static Future<SuperResponse<PaginatedSalonResponse>> getSalonFeed(
      int pageNo) async {
    // var addresses =
    //     await Geocoder.local.findAddressesFromQuery("sai pooja apartment");
    var latitude = "19.075983";
    var longitude = "72.877655";
    // if (addresses != null && addresses.first != null) {
    //   latitude = addresses.first.coordinates.latitude.toString();
    //   longitude = addresses.first.coordinates.longitude.toString();
    // }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    }
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {
      "authToken": loginAuthToken,
      "latUser": latitude,
      "longUser": longitude
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

  static Future<SuperResponse<SaloonServices>> getService(int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "salonId": 1};
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

  static Future<SuperResponse<List<Services>>> getServicesList() async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    // var userProfile = await AppSessionManager.getUserProfile();
    // print(authToken);

    final body = {"authToken": loginAuthToken, "salonId": 1};

    print(
        "http://staging.saloonwala.in/consumercloudspa/api/rs/v1/service/get/consumer/services");
    print(body);

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

      debugPrint(response.body);
      Map<String, dynamic> map = json.decode(response.body);
      Iterable data = map['data']['list'];
      List<Services> servicesList =
          data.map((dynamic ts) => Services.fromJson(ts)).toList();
      return SuperResponse.fromJson(map, servicesList);
    });
  }

  static Future<SuperResponse<SalonData>> getSingleStore(int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "id": salonId};
    debugPrint("${Constants.SecondryUrl}${Constants.GetSingleStore}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.SecondryUrl}${Constants.GetSingleStore}",
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
      return SuperResponse.fromJson(map, SalonData.fromJson(map['data']));
    });
  }
}
