class UserProfile {
  int id;
  String countryCode;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  int creationDate;
  String type;
  String modificationDate;
  String dob;
  String fbId;
  String username;
  String password;
  int salonId;
  String googleId;
  String profileUrl;
  String gender;
  int roleId;

  UserProfile(
      {this.id,
      this.countryCode,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.creationDate,
      this.type,
      this.modificationDate,
      this.dob,
      this.fbId,
      this.username,
      this.password,
      this.salonId,
      this.googleId,
      this.profileUrl,
      this.gender,
      this.roleId});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['countryCode'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    creationDate = json['creationDate'];
    type = json['type'];
    modificationDate = json['modificationDate'];
    dob = json['dob'];
    fbId = json['fbId'];
    username = json['username'];
    password = json['password'];
    salonId = json['salonId'];
    googleId = json['googleId'];
    profileUrl = json['profileUrl'];
    gender = json['gender'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryCode'] = this.countryCode;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['creationDate'] = this.creationDate;
    data['type'] = this.type;
    data['modificationDate'] = this.modificationDate;
    data['dob'] = this.dob;
    data['fbId'] = this.fbId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['salonId'] = this.salonId;
    data['googleId'] = this.googleId;
    data['profileUrl'] = this.profileUrl;
    data['gender'] = this.gender;
    data['roleId'] = this.roleId;
    return data;
  }
}
