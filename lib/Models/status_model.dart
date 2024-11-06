class StatusModel {
  String? docid;
  String? imageurl;
  String? title;
  String? message;
  StatusModel({this.docid, this.imageurl, this.message, this.title});

  toMap() {
    Map<String, dynamic> map = Map();
    map['docid'] = docid;
    map['imageurl'] = imageurl;
    map['title'] = title;
    map['message'] = message;
    return map;
  }
}
