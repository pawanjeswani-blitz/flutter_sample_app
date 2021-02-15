import 'dart:convert';

import 'package:saloonwala_consumer/model/info_bean.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSessionManager {
  static Future<String> getNonLoginAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('non_login_auth_token'))
      return prefs.getString('non_login_auth_token');
    else
      return null;
  }

  static setNonLoginAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('non_login_auth_token', token);
  }

  static saveInfoBean(InfoBean infoBean) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(infoBean.toJson());
    await prefs.setString('info_bean', userJson);
  }

  static Future<InfoBean> getInfoBean() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('info_bean')) {
      Map<String, dynamic> map = jsonDecode(prefs.getString('info_bean'));
      return InfoBean.fromJson(map);
    }
    return null;
  }
}
