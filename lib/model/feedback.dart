class FeedBack {
  List<FeedBackModel> list;
  int pageNo;
  bool hasMore;

  FeedBack({this.list, this.pageNo, this.hasMore});

  FeedBack.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<FeedBackModel>();
      json['list'].forEach((v) {
        list.add(new FeedBackModel.fromJson(v));
      });
    }
    pageNo = json['pageNo'];
    hasMore = json['hasMore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['pageNo'] = this.pageNo;
    data['hasMore'] = this.hasMore;
    return data;
  }
}

class FeedBackModel {
  int id;
  int userId;
  int salonId;
  int rating;
  String comment;
  int bookingId;
  UserDetails userDetails;

  FeedBackModel(
      {this.id,
      this.userId,
      this.salonId,
      this.rating,
      this.comment,
      this.bookingId,
      this.userDetails});

  FeedBackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    salonId = json['salonId'];
    rating = json['rating'];
    comment = json['comment'];
    bookingId = json['bookingId'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['salonId'] = this.salonId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['bookingId'] = this.bookingId;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails.toJson();
    }
    return data;
  }
}

class UserDetails {
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
  String gender;

  UserDetails(
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
      this.salonId,
      this.gender});

  UserDetails.fromJson(Map<String, dynamic> json) {
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
    gender = json['gender'];
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
    data['gender'] = this.gender;
    return data;
  }
}
