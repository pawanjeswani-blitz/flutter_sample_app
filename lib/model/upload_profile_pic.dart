class UploadProfilePic {
  dynamic error;
  String profilepicUrl;

  UploadProfilePic({this.profilepicUrl, this.error});

  UploadProfilePic.fromJson(Map<String, dynamic> json) {
    profilepicUrl = json['profilepicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilepicUrl'] = this.profilepicUrl;
    return data;
  }
}
