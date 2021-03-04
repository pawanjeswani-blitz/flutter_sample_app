class EmpInfo {
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
  int salonId;

  EmpInfo(
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
      this.salonId});

  EmpInfo.fromJson(Map<String, dynamic> json) {
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
    salonId = json['salonId'];
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
    data['salonId'] = this.salonId;
    return data;
  }
}
