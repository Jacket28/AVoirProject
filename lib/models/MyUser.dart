import 'dart:core';

//This class is used to interact with the events objects in the firebase database
class MyUser {
  String id = "";

  String email = "";
  String username = "";
  String password = "";

  bool isServiceProvider;
  bool isSubscribed;

  String url = "";

  //Used to translate attributes to JSON for the DB.
  Map<String, Object?> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'isServiceProvider': isServiceProvider,
      'isSubscribed': isSubscribed,
      'url': url,
    };
  }

  MyUser({
    required this.email,
    required this.username,
    required this.password,
    required this.isServiceProvider,
    required this.isSubscribed,
    required this.url,
  });

  //Used to translate from DB.
  MyUser.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
          username: json['username']! as String,
          password: json['password']! as String,
          isServiceProvider: json['isServiceProvider']! as bool,
          isSubscribed: json['isSubscribed']! as bool,
          url: json['url'] as String,
        );

  String get user_id {
    return id;
  }

  set user_id(String id) {
    this.id = id;
  }

  bool hasId() {
    if (this.id != "") {
      return true;
    }
    return false;
  }

  String get user_email {
    return email;
  }

  set user_email(String email) {
    this.email = email;
  }

  String get user_password {
    return password;
  }

  set user_password(String password) {
    this.password = password;
  }

  String get user_username {
    return username;
  }

  set user_username(String username) {
    this.username = username;
  }

  bool get user_isServiceProvider {
    return isServiceProvider;
  }

  set user_isServiceProvider(bool isServiceProvider) {
    this.isServiceProvider = isServiceProvider;
  }

  bool get user_isSubscribed {
    return isSubscribed;
  }

  set user_isSubscribed(bool isSubscribed) {
    this.isSubscribed = isSubscribed;
  }

  String get user_url {
    return url;
  }

  set user_url(String url) {
    this.url = url;
  }
}
