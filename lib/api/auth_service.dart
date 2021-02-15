import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:saloonwala_consumer/app/constants.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/model/info_bean.dart';
import 'package:http/http.dart' as http;
import 'package:saloonwala_consumer/model/non_login_response.dart';
import 'package:saloonwala_consumer/model/otp_response.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:package_info/package_info.dart';

class AuthService {
  static Future<SuperResponse<NonLoginResponse>> getNonAuthToken() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // final fcmToken = await firebaseMessaging.getToken();
    final body = {};

    InfoBean infoBean;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      infoBean = InfoBean(
          androidId: androidInfo.version.sdkInt.toString(),
          androidVersion: androidInfo.version.release,
          appName: 'Saloonwala Consumer',
          appSignature: "-1475535803",
          appVersion: packageInfo.version,
          deviceModel: androidInfo.model,
          fcmId: "fcmToken",
          manufacturer: androidInfo.manufacturer,
          userAgent: 'Android',
          platform: 'APP');

      body['androidUniqueId'] =
          '${androidInfo.androidId}_${DateTime.now().millisecondsSinceEpoch}';
      body['infoBean'] = infoBean;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      infoBean = InfoBean(
          androidId: null,
          androidVersion: null,
          appName: 'Saloonwala Partner',
          appSignature: "-1475535803", //this will figure it out latter,
          appVersion: packageInfo.version,
          deviceModel: iosInfo.utsname.machine,
          fcmId: "fcmToken",
          manufacturer: 'Apple',
          userAgent: 'iOS',
          platform: 'APP');

      body['androidUniqueId'] = iosInfo.identifierForVendor;
      body['infoBean'] = infoBean;
    }
    debugPrint("${Constants.BaseUrl}${Constants.NonLoginAuth}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.NonLoginAuth}",
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
      if (map['error'] == null) {
        final output =
            SuperResponse.fromJson(map, NonLoginResponse.fromJson(map['data']));
        AppSessionManager.setNonLoginAuthToken(output.data.authToken);
        AppSessionManager.saveInfoBean(infoBean);
        return output;
      } else
        return SuperResponse.fromJson(map, null);
    });
  }

  static Future<SuperResponse<bool>> getOTP(
      String countryCode, String mobileNumber) async {
    final nonLoginAuthToken = await AppSessionManager.getNonLoginAuthToken();

    final body = {
      "appPackageName": "Saloonwala Consumer",
      "countryCode": countryCode,
      "nonLoginAuthToken": nonLoginAuthToken,
      "phoneNumber": mobileNumber
    };
    debugPrint("${Constants.BaseUrl}${Constants.LoginUsingOTP}");
    debugPrint(jsonEncode(body));
    return http
        .post("${Constants.BaseUrl}${Constants.LoginUsingOTP}",
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
