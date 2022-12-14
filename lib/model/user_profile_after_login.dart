class UserProfileResponseLogin {
  dynamic error;
  UserProfileLogin userProfileLogin;

  UserProfileResponseLogin({this.error, this.userProfileLogin});

  UserProfileResponseLogin.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    userProfileLogin = json['userProfileLogin'] != null
        ? new UserProfileLogin.fromJson(json['userProfileLogin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.userProfileLogin != null) {
      data['userProfileLogin'] = this.userProfileLogin.toJson();
    }
    return data;
  }
}

class UserProfileLogin {
  String cityName;
  String stateName;
  String firstName;
  String lastName;
  String profileUrl;
  int creationDate;
  int age;
  String type;
  String email;
  String phoneNumber;
  String dob;
  int roleId;
  String gender;
  String address;

  UserProfileLogin(
      {this.cityName,
      this.stateName,
      this.firstName,
      this.lastName,
      this.profileUrl,
      this.creationDate,
      this.age,
      this.type,
      this.email,
      this.phoneNumber,
      this.dob,
      this.roleId,
      this.gender,
      this.address});

  UserProfileLogin.fromJson(Map<String, dynamic> json) {
    cityName = json['cityName'];
    stateName = json['stateName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profileUrl = json['profileUrl'];
    creationDate = json['creationDate'];
    age = json['age'];
    type = json['type'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    dob = json['dob'];
    roleId = json['roleId'];
    gender = json['gender'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profileUrl'] = this.profileUrl;
    data['creationDate'] = this.creationDate;
    data['age'] = this.age;
    data['type'] = this.type;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['dob'] = this.dob;
    data['roleId'] = this.roleId;
    data['gender'] = this.gender;
    data['address'] = this.address;
    return data;
  }
}
