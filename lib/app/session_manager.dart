import 'dart:convert';

import 'package:saloonwala_consumer/model/info_bean.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
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

  static Future<String> getLoginAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('login_auth_token'))
      return prefs.getString('login_auth_token');
    else
      return null;
  }

  static setLoginAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_auth_token', token);
  }

  static saveUserProfileObject(UserProfile user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user_profile', userJson);
  }

  static Future<UserProfile> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_profile')) {
      Map<String, dynamic> map = jsonDecode(prefs.getString('user_profile'));
      return UserProfile.fromJson(map);
    } else
      return null;
  }

  static saveUserProfileAfterLogin(UserProfileLogin userProfileLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userprofileJson = jsonEncode(userProfileLogin.toJson());
    await prefs.setString('user_profile_after_login', userprofileJson);
  }

  static Future<UserProfileLogin> getUserProfileAfterLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_profile_after_login')) {
      Map<String, dynamic> map =
          jsonDecode(prefs.getString('user_profile_after_login'));
      return UserProfileLogin.fromJson(map);
    } else
      return null;
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
