import 'package:saloonwala_consumer/model/employee.dart';
import 'package:saloonwala_consumer/model/slots.dart';

class AvailableSlotsResponse {
  List<Slots> slots;
  Map<String, List<Employee>> slotMap;

  AvailableSlotsResponse({this.slots, this.slotMap});

  AvailableSlotsResponse.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = new List<Slots>();
      json['slots'].forEach((v) {
        slots.add(new Slots.fromJson(v));
      });
    }

    if (json['slotMap'] != null) {
      slotMap = {};
      json['slotMap'].forEach((key, value) {
        List<Employee> employeeList = new List<Employee>();
        value.forEach((emp) {
          employeeList.add(new Employee.fromJson(emp));
        });

        slotMap[key] = employeeList;
      });
    }
  }
}
