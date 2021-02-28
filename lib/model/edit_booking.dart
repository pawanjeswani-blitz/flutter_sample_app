class EditBooking {
  dynamic error;
  bool success;

  EditBooking({this.success, this.error});

  EditBooking.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    return data;
  }
}
