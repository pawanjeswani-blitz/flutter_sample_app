import 'package:saloonwala_consumer/model/appointment_response.dart';

class GetAppointment {
  List<AppointmentResponse> list;
  int pageNo;
  bool hasMore;

  GetAppointment({this.list, this.pageNo, this.hasMore});

  GetAppointment.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<AppointmentResponse>();
      json['list'].forEach((v) {
        list.add(new AppointmentResponse.fromJson(v));
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
