class SalonData {
  int id;
  String name;
  String address;
  String cityName;
  String stateName;
  String latitude;
  String longitude;
  int parentStore;
  String category;
  bool active;
  String subscriptionType;
  String emailId;
  int creationDate;
  int revenue;
  int jobCount;
  String ownerName;
  String phoneNumber;
  double distance;
  String thumbnail1;
  String thumbnail2;
  String thumbnail3;
  String thumbnail4;
  String planType;
  bool offline;
  bool like;

  SalonData(
      {this.id,
      this.name,
      this.address,
      this.cityName,
      this.stateName,
      this.latitude,
      this.longitude,
      this.parentStore,
      this.category,
      this.active,
      this.subscriptionType,
      this.emailId,
      this.creationDate,
      this.revenue,
      this.jobCount,
      this.ownerName,
      this.phoneNumber,
      this.distance,
      this.thumbnail1,
      this.thumbnail2,
      this.thumbnail3,
      this.thumbnail4,
      this.planType,
      this.offline,
      this.like});

  SalonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    parentStore = json['parentStore'];
    category = json['category'];
    active = json['active'];
    subscriptionType = json['subscriptionType'];
    emailId = json['emailId'];
    creationDate = json['creationDate'];
    revenue = json['revenue'];
    jobCount = json['jobCount'];
    ownerName = json['ownerName'];
    phoneNumber = json['phoneNumber'];
    distance = json['distance'];
    thumbnail1 = json['thumbnail1'];
    thumbnail2 = json['thumbnail2'];
    thumbnail3 = json['thumbnail3'];
    thumbnail4 = json['thumbnail4'];
    planType = json['planType'];
    offline = json['offline'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['parentStore'] = this.parentStore;
    data['category'] = this.category;
    data['active'] = this.active;
    data['subscriptionType'] = this.subscriptionType;
    data['emailId'] = this.emailId;
    data['creationDate'] = this.creationDate;
    data['revenue'] = this.revenue;
    data['jobCount'] = this.jobCount;
    data['ownerName'] = this.ownerName;
    data['phoneNumber'] = this.phoneNumber;
    data['distance'] = this.distance;
    data['thumbnail1'] = this.thumbnail1;
    data['thumbnail2'] = this.thumbnail2;
    data['thumbnail3'] = this.thumbnail3;
    data['thumbnail4'] = this.thumbnail4;
    data['planType'] = this.planType;
    data['offline'] = this.offline;
    data['like'] = this.like;
    return data;
  }
}
