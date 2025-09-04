class PastEvents {
  List<Event>? events;

  PastEvents({this.events});

  PastEvents.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Event>[];
      json['events'].forEach((v) {
        events!.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  int? id;
  String? name;
  String? theme;
  String? eventdate;
  String? flyerUrl;

  Event({this.id, this.name, this.theme, this.eventdate, this.flyerUrl});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    theme = json['theme'];
    eventdate = json['eventdate'];
    flyerUrl = json['flyer_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['theme'] = this.theme;
    data['eventdate'] = this.eventdate;
    data['flyer_url'] = this.flyerUrl;
    return data;
  }
}
