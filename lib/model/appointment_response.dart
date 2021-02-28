import 'package:saloonwala_consumer/model/appointment_salon_details.dart';
import 'package:saloonwala_consumer/model/appointment_service_info.dart';
import 'package:saloonwala_consumer/model/customer_info.dart';
import 'package:saloonwala_consumer/model/emp_info.dart';

class AppointmentResponse {
  int id;
  int custId;
  int empId;
  int startTime;
  int endTime;
  int salonId;
  String status;
  int creationDate;
  int modificationDate;
  String customerName;
  String customerNumber;
  String date;
  CustomerInfo customerInfo;
  EmpInfo empInfo;
  List<ServiceInfo> serviceInfo;
  SalonDetails salonDetails;

  AppointmentResponse(
      {this.id,
      this.custId,
      this.empId,
      this.startTime,
      this.endTime,
      this.salonId,
      this.status,
      this.creationDate,
      this.modificationDate,
      this.customerName,
      this.customerNumber,
      this.date,
      this.customerInfo,
      this.empInfo,
      this.serviceInfo,
      this.salonDetails});

  AppointmentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    custId = json['custId'];
    empId = json['empId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    salonId = json['salonId'];
    status = json['status'];
    creationDate = json['creationDate'];
    modificationDate = json['modificationDate'];
    customerName = json['customerName'];
    customerNumber = json['customerNumber'];
    date = json['date'];
    customerInfo = json['customerInfo'] != null
        ? new CustomerInfo.fromJson(json['customerInfo'])
        : null;
    empInfo =
        json['empInfo'] != null ? new EmpInfo.fromJson(json['empInfo']) : null;
    if (json['serviceInfo'] != null) {
      serviceInfo = new List<ServiceInfo>();
      json['serviceInfo'].forEach((v) {
        serviceInfo.add(new ServiceInfo.fromJson(v));
      });
    }
    salonDetails = json['salonDetails'] != null
        ? new SalonDetails.fromJson(json['salonDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['custId'] = this.custId;
    data['empId'] = this.empId;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['salonId'] = this.salonId;
    data['status'] = this.status;
    data['creationDate'] = this.creationDate;
    data['modificationDate'] = this.modificationDate;
    data['customerName'] = this.customerName;
    data['customerNumber'] = this.customerNumber;
    data['date'] = this.date;
    if (this.customerInfo != null) {
      data['customerInfo'] = this.customerInfo.toJson();
    }
    if (this.empInfo != null) {
      data['empInfo'] = this.empInfo.toJson();
    }
    if (this.serviceInfo != null) {
      data['serviceInfo'] = this.serviceInfo.map((v) => v.toJson()).toList();
    }
    if (this.salonDetails != null) {
      data['salonDetails'] = this.salonDetails.toJson();
    }
    return data;
  }
}
