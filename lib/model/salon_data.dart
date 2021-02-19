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
  Null ownerName;
  String phoneNumber;
  double distance;

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
      this.distance});

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
    return data;
  }
}
