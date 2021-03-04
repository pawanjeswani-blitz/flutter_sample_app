class FeedBack {
  List<FeedBackModel> list;
  int pageNo;
  bool hasMore;

  FeedBack({this.list, this.pageNo, this.hasMore});

  FeedBack.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<FeedBackModel>();
      json['list'].forEach((v) {
        list.add(new FeedBackModel.fromJson(v));
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

class FeedBackModel {
  int id;
  int userId;
  int salonId;
  int rating;
  String comment;
  int bookingId;

  FeedBackModel(
      {this.id,
      this.userId,
      this.salonId,
      this.rating,
      this.comment,
      this.bookingId});

  FeedBackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    salonId = json['salonId'];
    rating = json['rating'];
    comment = json['comment'];
    bookingId = json['bookingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['salonId'] = this.salonId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['bookingId'] = this.bookingId;
    return data;
  }
}
