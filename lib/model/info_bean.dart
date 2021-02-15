class InfoBean {
  String androidId;
  String androidVersion;
  String appName;
  String appSignature;
  String appVersion;
  String deviceModel;
  String fcmId;
  String manufacturer;
  String platform;
  String userAgent;

  InfoBean(
      {this.androidId,
      this.androidVersion,
      this.appName,
      this.appSignature,
      this.appVersion,
      this.deviceModel,
      this.fcmId,
      this.manufacturer,
      this.platform,
      this.userAgent});

  InfoBean.fromJson(Map<String, dynamic> json) {
    androidId = json['androidId'];
    androidVersion = json['androidVersion'];
    appName = json['appName'];
    appSignature = json['appSignature'];
    appVersion = json['appVersion'];
    deviceModel = json['deviceModel'];
    fcmId = json['fcmId'];
    manufacturer = json['manufacturer'];
    platform = json['platform'];
    userAgent = json['userAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['androidId'] = this.androidId;
    data['androidVersion'] = this.androidVersion;
    data['appName'] = this.appName;
    data['appSignature'] = this.appSignature;
    data['appVersion'] = this.appVersion;
    data['deviceModel'] = this.deviceModel;
    data['fcmId'] = this.fcmId;
    data['manufacturer'] = this.manufacturer;
    data['platform'] = this.platform;
    data['userAgent'] = this.userAgent;
    return data;
  }
}
