import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/update_profile.dart';
import 'package:http/http.dart' as http;
import 'package:saloonwala_consumer/model/upload_profile_pic.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';

class UserProfileService {
  static Future<SuperResponse<UpdateProfile>> updateUserProfile(
    String firstName,
    String lastName,
    String dob,
    String city,
    String state,
    String gender,
    String email,
    String address,
  ) async {
    var latitude = "19.075983";
    var longitude = "72.877655";
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    }
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();
    final body = {
      "authToken": loginAuthToken,
      "cityName": city,
      "dob": dob,
      "firstName": firstName,
      "gender": gender,
      "lastName": lastName,
      "latitude": latitude,
      "longitude": longitude,
      "stateName": state,
      "email": email,
      "address": address
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
    String firstName,
    String lastName,
    String dob,
    String city,
    String state,
    String gender,
    String email,
    String address,
  ) async {
    // String dob, city, state;
    final loginAuthToken = await AppSessionManager.getLoginAuthToken();

    final body = {
      "authToken": loginAuthToken,
      "cityName": city,
      "dob": dob,
      "firstName": firstName,
      "gender": gender,
      "lastName": lastName,
      "stateName": state,
      "email": email,
      "address": address
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

  static Future<SuperResponse<UploadProfilePic>> uploadProfileImage(
    String filePath1,
  ) async {
    var authToken = await AppSessionManager.getLoginAuthToken();

    final map = Map<String, dynamic>();
    map['authToken '] = authToken;

    if (filePath1 != null && filePath1.isNotEmpty) {
      print('adding 1 key');
      map['profilePic'] = await MultipartFile.fromFile(filePath1,
          filename: "profilePic.png", contentType: MediaType('image', 'jpeg'));
    } else
      map['profilePic'] = null;

    var formData = FormData.fromMap(map);

    print('--------------------');

    // var response = await Dio().post(
    //     "${Constants.BaseUrl}${Constants.UploadProfilePic}",
    //     data: formData);
    // print(response.data['data']['profilepicUrl']);

    // debugPrint('Debug Url ${response.data['data']['profilepicUrl']}');
    // Map<String, dynamic> map2 = json.decode(response.data);
    try {
      final response = await Dio().post(
        "${Constants.BaseUrl}${Constants.UploadProfilePic}",
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      return SuperResponse.fromJson(
          map, UploadProfilePic.fromJson(response.data['data']));
      // return BannerImages(thumbnail1: response.data['thumbnail1']);
    } on DioError catch (e) {
      return SuperResponse(error: "Error While Uploading ${e.toString()}");
    }
    // return SuperResponse.fromJson(map, UploadProfilePic.fromJson(map2['data']));
  }
}
