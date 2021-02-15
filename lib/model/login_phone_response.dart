import 'package:saloonwala_consumer/view/pages/user_profile.dart';

class Data {
  bool userExists;
  String authToken;
  String refreshToken;
  UserProfile userProfile;
  dynamic salonList;
  dynamic nextUrl;

  Data(
      {this.userExists,
      this.authToken,
      this.refreshToken,
      this.userProfile,
      this.salonList,
      this.nextUrl});

  Data.fromJson(Map<String, dynamic> json) {
    userExists = json['userExists'];
    authToken = json['authToken'];
    refreshToken = json['refreshToken'];
    userProfile = json['userProfile'];
    salonList = json['salonList'];
    nextUrl = json['nextUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userExists'] = this.userExists;
    data['authToken'] = this.authToken;
    data['refreshToken'] = this.refreshToken;
    data['userProfile'] = this.userProfile;
    data['salonList'] = this.salonList;
    data['nextUrl'] = this.nextUrl;
    return data;
  }
}
