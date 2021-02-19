import 'package:saloonwala_consumer/model/salon_data.dart';

class PaginatedSalonResponse {
  List<SalonData> list;
  int pageNo;
  bool hasMore;

  PaginatedSalonResponse({this.list, this.pageNo, this.hasMore});

  PaginatedSalonResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<SalonData>();
      json['list'].forEach((v) {
        list.add(new SalonData.fromJson(v));
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
