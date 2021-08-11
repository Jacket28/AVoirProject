import 'dart:core';

//This class is used to interact with the events objects in the firebase database
class MyEvent {
  String id = "";

  String title = "";
  String description = "";
  String address = "";
  String npa = "";
  String city = "";
  String date = "";
  String time = "";

  //Used to translate attributes to JSON for the DB.
  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'npa': npa,
      'city': city,
      'date': date,
      'time': time
    };
  }

  MyEvent(
      {required this.title,
      required this.description,
      required this.address,
      required this.npa,
      required this.city,
      required this.date,
      required this.time});

  //Used to translate from DB.
  MyEvent.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          description: json['description']! as String,
          address: json['address']! as String,
          npa: json['npa']! as String,
          city: json['city']! as String,
          date: json['date']! as String,
          time: json['time']! as String,
        );

  String get event_id {
    return id;
  }

  set event_id(String id) {
    this.id = id;
  }

  bool hasId() {
    if (this.id != "") {
      return true;
    }
    return false;
  }

  String get event_title {
    return title;
  }

  set event_title(String title) {
    this.title = title;
  }

  String get event_description {
    return description;
  }

  set event_desription(String description) {
    this.description = description;
  }

  String get event_adress {
    return address;
  }

  set event_adress(String address) {
    this.address = address;
  }

  String get event_npa {
    return npa;
  }

  set event_npa(String npa) {
    this.npa = npa;
  }

  String get event_city {
    return city;
  }

  set event_city(String city) {
    this.city = city;
  }

  String get event_date {
    return date;
  }

  set event_date(String date) {
    this.date = date;
  }

  String get event_time {
    return time;
  }

  set event_time(String time) {
    this.time = time;
  }
}
