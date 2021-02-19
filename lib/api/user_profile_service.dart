import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/update_profile.dart';
import 'package:http/http.dart' as http;
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';

class UserProfileService {
  static Future<SuperResponse<UpdateProfile>> updateUserProfile(
      String firstName,
      String lastName,
      String dob,
      String city,
      String state,
      String gender) async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "cityName": city,
      "dob": dob,
      "firstName": firstName,
      "gender": gender,
      "lastName": lastName,
      "latitude": "19",
      "longitude": "23",
      "profileUrl": " ",
      "stateName": state
    };
    debugPrint("${Constants.BaseUrl}${Constants.UpdateUserProfile}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.UpdateUserProfile}",
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

  static Future<SuperResponse<UserProfileLogin>>
      getUserProfileAfterLogin() async {
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    String userId;
    Future<UserProfile> userProfileData = AppSessionManager.getUserProfile();
    await userProfileData.then((value) {
      userId = value.id.toString();
    });
    final body = {"authToken": loginAuthToken, "userId": userId};
    debugPrint("${Constants.BaseUrl}${Constants.GetUserProfilePath}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.GetUserProfilePath}",
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
      final output =
          SuperResponse.fromJson(map, UserProfileLogin.fromJson(map['data']));
      if (output.data.firstName != null) {
        AppSessionManager.saveUserProfileAfterLogin(output.data);
      }
      return output;
    });
  }

  static Future<SuperResponse<UpdateProfile>> updateUserProfileFromEditProfile(
      String firstName, String lastName, String gender) async {
    String dob, city, state;
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    Future<UserProfileLogin> userProfileData =
        AppSessionManager.getUserProfileAfterLogin();
    await userProfileData.then((value) {
      dob = value.dob.toString();
      city = value.cityName;
      state = value.stateName;
    });

    final body = {
      "authToken": loginAuthToken,
      "cityName": city,
      "dob": dob,
      "firstName": firstName,
      "gender": gender,
      "lastName": lastName,
      "latitude": "19",
      "longitude": "23",
      "profileUrl": " ",
      "stateName": state
    };
    debugPrint("${Constants.BaseUrl}${Constants.UpdateUserProfile}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.UpdateUserProfile}",
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
