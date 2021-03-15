import 'package:saloonwala_consumer/model/user_profile.dart';

class LoginPhoneResponse {
  bool userExists;
  String authToken;
  String refreshToken;
  UserProfile userProfile;
  dynamic salonList;
  dynamic nextUrl;

  LoginPhoneResponse(
      {this.userExists,
      this.authToken,
      this.refreshToken,
      this.userProfile,
      this.salonList,
      this.nextUrl});

  LoginPhoneResponse.fromJson(Map<String, dynamic> json) {
    userExists = json['userExists'];
    authToken = json['authToken'];
    refreshToken = json['refreshToken'];
    userProfile = json['userProfile'] != null
        ? new UserProfile.fromJson(json['userProfile'])
        : null;
    salonList = json['salonList'];
    nextUrl = json['nextUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userExists'] = this.userExists;
    data['authToken'] = this.authToken;
    data['refreshToken'] = this.refreshToken;
    if (this.userProfile != null) {
      data['userProfile'] = this.userProfile.toJson();
    }
    data['salonList'] = this.salonList;
    data['nextUrl'] = this.nextUrl;
    return data;
  }
}
