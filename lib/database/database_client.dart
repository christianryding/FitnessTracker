import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'story.dart';
import 'user.dart';

class DatabaseClient {
  Database _db;

  /*Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");

    _db = await openDatabase(dbPath, version: 1);
  }*/
  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "tradecraft.db");

    _db = await openDatabase(dbPath, version: 1,
        onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE story (
              id INTEGER PRIMARY KEY, 
              user_id INTEGER NOT NULL,
              title TEXT NOT NULL,
              body TEXT NOT NULL,
              FOREIGN KEY (user_id) REFERENCES user (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");

    await db.execute("""
            CREATE TABLE user (
              id INTEGER PRIMARY KEY,
              username TEXT NOT NULL UNIQUE
            )""");
  }


  Future<User> upsertUser(User user) async {
    var count = Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM user WHERE username = ?", [user.username]));
    if (count == 0) {
      user.id = await _db.insert("user", user.toMap());
    } else {
      await _db.update("user", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    }

    return user;
  }

  Future<Story> upsertStory(Story story) async {
    if (story.id == null) {
      story.id = await _db.insert("story", story.toMap());
    } else {
      await _db.update("story", story.toMap(), where: "id = ?", whereArgs: [story.id]);
    }

    return story;
  }

  Future<User> fetchUser(int id) async {
    List<Map> results = await _db.query("user", columns: User.columns, where: "id = ?", whereArgs: [id]);

    User user = User.fromMap(results[0]);

    return user;
  }

  Future<Story> fetchStory(int id) async {
    List<Map> results = await _db.query("story", columns: Story.columns, where: "id = ?", whereArgs: [id]);

    Story story = Story.fromMap(results[0]);

    return story;
  }

  Future<List<Story>> fetchLatestStories(int limit) async {
    List<Map> results = await _db.query("story", columns: Story.columns, limit: limit, orderBy: "id DESC");

    List<Story> stories = new List();
    results.forEach((result) {
      Story story = Story.fromMap(result);
      stories.add(story);
    });

    return stories;
  }

  Future<Story> fetchStoryAndUser(int storyId) async {
    List<Map> results = await _db.query("story", columns: Story.columns, where: "id = ?", whereArgs: [storyId]);

    Story story = Story.fromMap(results[0]);
    story.user = await fetchUser(story.user_id);

    return story;
  }

}

