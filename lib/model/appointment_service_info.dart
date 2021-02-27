class ServiceInfo {
  int id;
  String serviceName;
  String description;
  int globalDiscount;
  int serviceDiscount;
  int rate;
  int femaleRate;
  int maleRate;

  ServiceInfo(
      {this.id,
      this.serviceName,
      this.description,
      this.globalDiscount,
      this.serviceDiscount,
      this.rate,
      this.femaleRate,
      this.maleRate});

  ServiceInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceName = json['serviceName'];
    description = json['description'];
    globalDiscount = json['globalDiscount'];
    serviceDiscount = json['serviceDiscount'];
    rate = json['rate'];
    femaleRate = json['femaleRate'];
    maleRate = json['maleRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serviceName'] = this.serviceName;
    data['description'] = this.description;
    data['globalDiscount'] = this.globalDiscount;
    data['serviceDiscount'] = this.serviceDiscount;
    data['rate'] = this.rate;
    data['femaleRate'] = this.femaleRate;
    data['maleRate'] = this.maleRate;
    return data;
  }
}
