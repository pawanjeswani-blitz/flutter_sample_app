import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/favorite_update.dart';
import 'package:saloonwala_consumer/model/paginated_salon_response.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FavoriteService {
  static Future<SuperResponse<FavoriteUpdate>> favoriteUpdate(
      int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "like": true,
      "saloonList": [salonId]
    };
    debugPrint("${Constants.SecondryUrl}${Constants.FavoriteUpdateHeart}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.SecondryUrl}${Constants.FavoriteUpdateHeart}",
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

  static Future<SuperResponse<PaginatedSalonResponse>>
      getSalonFeedForFavorite() async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {"authToken": loginAuthToken};
    debugPrint("${Constants.SecondryUrl}${Constants.GetLikedSalon}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.SecondryUrl}${Constants.GetLikedSalon}",
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

  static Future<SuperResponse<FavoriteUpdate>> favoriteRemove(
      int salonId) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "like": false,
      "saloonList": [salonId]
    };
    debugPrint("${Constants.SecondryUrl}${Constants.FavoriteUpdateHeart}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.SecondryUrl}${Constants.FavoriteUpdateHeart}",
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
