class SuperResponse<T> {
  dynamic error;
  T data;

  SuperResponse({this.error, this.data});

  factory SuperResponse.fromJson(Map<String, dynamic> json, T t) {
    return SuperResponse<T>(error: json['error'], data: t);
  }
}
