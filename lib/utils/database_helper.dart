import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';
import '../models/user.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String noteTable = 'note_table';
  String foreignTable = 'foreign_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes14.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $noteTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT, '
        '$colDescription TEXT, '
        'FOREIGN KEY ($colId) REFERENCES user (id) ) '
    );

    await db.execute('''
          INSERT INTO $noteTable
            ($colId, $colTitle,$colDescription)
          VALUES
            (1,"Summer PreWorkout", "w1"),
            (2,"Winter PreWorkout", "w1"),
            (3,"After Summer Workout", "w1")'''
    );

    /* TEST METHODS */
    await db.execute("""
            CREATE TABLE user (
              id INTEGER PRIMARY KEY,
              username TEXT NOT NULL UNIQUE
            )""");
    // ADD ONE MORE COLUMN
    await db.execute('''
          INSERT INTO user
            (id, username)
          VALUES
            (1,"123"),
            (2,"456"),
            (3,"789")'''
    );
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }



  Future<User> upsertUser(User user) async {
    var count = Sqflite.firstIntValue(await _database.rawQuery("SELECT COUNT(*) FROM user WHERE username = ?", [user.username]));
    if (count == 0) {
      user.id = await _database.insert("user", user.toMap());
    } else {
      await _database.update("user", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    }
    return user;
  }

  Future<User> fetchUser(int id) async {
    List<Map> results = await _database.query("user", columns: User.columns, where: "id = ?", whereArgs: [id]);

    User user = User.fromMap(results[0]);

    return user;
  }

  Future<Note> fetchNoteAndUser(int noteId) async {
    List<Map> results = await _database.query("note_table", columns: Note.columns, where: "id = ?", whereArgs: [noteId]);

    Note note = Note.fromMapObject(results[0]);
    note.user = await fetchUser(note.id);

    return note;
  }
}
