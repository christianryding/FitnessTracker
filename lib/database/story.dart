import 'dart:convert';
import 'user.dart';

class Story {
  Story();

  int id;
  String title;
  String body;
  int user_id;
  User user;

  static final columns = ["id", "title", "body", "user_id"];

  Map toMap() {
    Map map = {
      "title": title,
      "body": body,
      "user_id": user_id,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    Story story = new Story();
    story.id = map["id"];
    story.title = map["title"];
    story.body = map["body"];
    story.user_id = map["user_id"];

    return story;
  }
}