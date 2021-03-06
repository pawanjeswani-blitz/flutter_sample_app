class Employee {
  int id;
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
  int salonId;
  int roleId;
  int salary;
  String userName;
  String password;
  String gender;
  String description;

  Employee(
      {this.id,
      this.cityName,
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
      this.salonId,
      this.roleId,
      this.salary,
      this.userName,
      this.password,
      this.gender,
      this.description});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    salonId = json['salonId'];
    roleId = json['roleId'];
    salary = json['salary'];
    userName = json['userName'];
    password = json['password'];
    gender = json['gender'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['salonId'] = this.salonId;
    data['roleId'] = this.roleId;
    data['salary'] = this.salary;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['description'] = this.description;
    return data;
  }
}
