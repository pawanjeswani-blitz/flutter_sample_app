import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/feedback.dart';
import 'package:saloonwala_consumer/model/post_feedback_response.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FeedBackService {
  static Future<SuperResponse<FeedBack>> getSalonRating(
      int pageNo, int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken, "salonId": salonId};
    debugPrint("${Constants.BaseUrl}${Constants.FeedBack}${pageNo.toString()}");
    debugPrint(jsonEncode(body));
    return http
        .post(Uri.parse("${Constants.BaseUrl}${Constants.FeedBack}${pageNo.toString()}"),
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
      return SuperResponse.fromJson(map, FeedBack.fromJson(map['data']));
    });
  }

  static Future<SuperResponse<PostFeedback>> postsalonRating(
      int salonId, int bookinId, int rating) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "bookingId": bookinId,
      "comment": " ",
      "ratingStore": rating,
      "salonId": salonId
    };
    debugPrint("${Constants.BaseUrl}${Constants.PostStoreRating}");
    debugPrint(jsonEncode(body));
    return http
        .post(Uri.parse("${Constants.BaseUrl}${Constants.PostStoreRating}"),
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

  static Future<SuperResponse<PostFeedback>> postsalonComment(
      int salonId, int bookinId, String comment) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "bookingId": bookinId,
      "comment": comment,
      "ratingStore": 0,
      "salonId": salonId
    };
    debugPrint("${Constants.BaseUrl}${Constants.PostStoreComment}");
    debugPrint(jsonEncode(body));
    return http
        .post(Uri.parse("${Constants.BaseUrl}${Constants.PostStoreComment}"),
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
