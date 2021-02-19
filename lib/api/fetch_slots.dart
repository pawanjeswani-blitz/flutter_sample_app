import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/model/available_slot_response.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';

class FetchSlots {
  static Future<SuperResponse<AvailableSlotsResponse>> getTitleSlot(
      DateTime dateTime) {
    final body = {
      "authToken":
          "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjcsImxvZ2luSWQiOjE2MiwicGxhdGZvcm0iOiJQaG9uZSIsImlhdCI6MTYxMTQ0MDQxNSwiZXhwIjoyNTQ0NTYwNDE1fQ.76uU_gFeVXkOq_cXqWHln934Iqr5-helYeRzYcXY6U4",
      "date": DateUtil.getDisplayFormatDate(dateTime),
      "salonId": 1
    };
    debugPrint("${Constants.SecondryUrl}${Constants.GetSalonSlots}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.SecondryUrl}${Constants.GetSalonSlots}",
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
}
