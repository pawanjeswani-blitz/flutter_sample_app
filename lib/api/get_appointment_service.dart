import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/appointment_response.dart';
import 'package:saloonwala_consumer/model/edit_booking.dart';
import 'package:saloonwala_consumer/model/get_appointment.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:http/http.dart' as http;

class GetAppointmentService {
  static Future<SuperResponse<GetAppointment>> getSalonFeed(int pageNo) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken};
    debugPrint(
        "${Constants.BaseUrl}${Constants.GetAppointmentData}${pageNo.toString()}");
    debugPrint(jsonEncode(body));
    return http
        .post(Uri.parse(
            "${Constants.BaseUrl}${Constants.GetAppointmentData}${pageNo.toString()}"),
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
      return SuperResponse.fromJson(map, GetAppointment.fromJson(map['data']));
    });
  }

  static Future<SuperResponse<EditBooking>> cancelAppointment(
      int bookingId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "bookingId": bookingId,
      "status": "CUST_CANCELLED"
    };
    debugPrint("${Constants.BaseUrl}${Constants.EditAppointMent}");
    debugPrint(jsonEncode(body));
    return http
        .post(Uri.parse("${Constants.BaseUrl}${Constants.EditAppointMent}"),
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
      return SuperResponse.fromJson(map, null);
    });
  }

  static Future<SuperResponse<AppointmentResponse>> getSingleAppointment(
      int bookingId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "bookingId": bookingId};
    debugPrint("${Constants.BaseUrl}${Constants.GetSingleAppointment}");
    debugPrint(jsonEncode(body));
    return http
        .post(Uri.parse("${Constants.BaseUrl}${Constants.GetSingleAppointment}"),
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
          map, AppointmentResponse.fromJson(map['data']));
    });
  }
}
