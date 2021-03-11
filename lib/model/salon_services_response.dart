import 'package:saloonwala_consumer/model/salon_services.dart';

class SalonServices {
  List<Services> services;
  int pageNo;
  bool hasMore;

  SalonServices({this.services, this.pageNo, this.hasMore});

  SalonServices.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      services = new List<Services>();
      json['list'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    pageNo = json['pageNo'];
    hasMore = json['hasMore'];
  }
}
