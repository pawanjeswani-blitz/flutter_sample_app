import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/available_slot_response.dart';
import 'package:saloonwala_consumer/model/book_slot.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';

class FetchSlots {
  static Future<SuperResponse<AvailableSlotsResponse>> getTitleSlot(
      DateTime dateTime, int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {
      "authToken": loginAuthToken,
      "date": DateUtil.getDisplayFormatDate(dateTime),
      "salonId": salonId
    };
    debugPrint("${Constants.BaseUrl}${Constants.GetSalonSlots}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.GetSalonSlots}",
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(body))
        .then((http.Response response) {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);
      return SuperResponse.fromJson(
          map, AvailableSlotsResponse.fromJson(map['data']));
    });
  }

  static Future<SuperResponse<BookSlot>> bookSlot(
      String selectedDate,
      int employeeId,
      int endTime,
      int salonId,
      int startTime,
      List<int> services) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "date": selectedDate,
      "employeeId": employeeId,
      "endTime": endTime,
      "salonId": salonId,
      "services": services,
      "startTime": startTime,
      "status": "REQUESTED"
    };
    debugPrint("${Constants.BaseUrl}${Constants.SlotsBooking}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.SlotsBooking}",
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
}
