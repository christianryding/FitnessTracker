import 'dart:convert';

class User {
  User();

  int id;
  String username;

  static final columns = ["id", "username"];

  Map toMap() {
    Map map = {
      "username": username,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    User user = new User();
    user.id = map["id"];
    user.username = map["username"];

    return user;
  }
}