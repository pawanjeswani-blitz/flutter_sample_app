class NonLoginResponse {
  String authToken;
  String refreshToken;
  String androidUniqueIId;

  NonLoginResponse({this.authToken, this.refreshToken, this.androidUniqueIId});

  NonLoginResponse.fromJson(Map<String, dynamic> json) {
    authToken = json['authToken'];
    refreshToken = json['refreshToken'];
    androidUniqueIId = json['androidUniqueIId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authToken'] = this.authToken;
    data['refreshToken'] = this.refreshToken;
    data['androidUniqueIId'] = this.androidUniqueIId;
    return data;
  }
}
