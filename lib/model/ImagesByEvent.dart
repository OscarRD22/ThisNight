class ImagesByEvent {
  List<MyImage>? images;

  ImagesByEvent({this.images});

  ImagesByEvent.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = <MyImage>[];
      json['images'].forEach((v) {
        images!.add(new MyImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyImage {
  int? id;
  String? type;
  String? name;
  String? url;

  MyImage({this.id, this.type, this.name, this.url});

  MyImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}
