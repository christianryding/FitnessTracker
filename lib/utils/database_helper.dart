import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/workouts.dart';
import '../models/workout_exercises.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  // Workout table
  String workoutTable = 'workout_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';

  //
  String foreignTable = 'foreign_table';

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
    String path = directory.path + 'notes19.db';

    // Open/create the database at a given path
    var workoutsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return workoutsDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $workoutTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT, '
        '$colDescription TEXT, '
        'FOREIGN KEY ($colId) REFERENCES user (id) ) '
    );

    await db.execute('''
          INSERT INTO $workoutTable
            ($colId, $colTitle,$colDescription)
          VALUES
            (1,"Summer PreWorkout", "Get ready for the beach!"),
            (2,"Winter PreWorkout", "Hmmmm...."),
            (3,"After Summer Workout", "Back at it!")'''
    );

    /* TEST METHODS */
    await db.execute("""
            CREATE TABLE workout_exercises (
              id INTEGER PRIMARY KEY,
              username TEXT NOT NULL UNIQUE,
              exerciseId INTEGER,
              workoutId INTEGER
            )""");
    // ADD ONE MORE COLUMN
    await db.execute('''
          INSERT INTO workout_exercises
            (id, username, exerciseId, workoutId)
          VALUES
            (1,"admin1",1,1),
            (2,"admin2",2,2),
            (3,"admin3",3,3)'''
    );
  }

  // Delete Operation: Delete a Workout object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $workoutTable WHERE $colId = $id');
    return result;
  }

  // Insert Operation: Insert a Workout object to database
  Future<int> insertNote(Workouts workout) async {
    Database db = await this.database;
    var result = await db.insert(workoutTable, workout.toMap());
    return result;
  }

  // Update Operation: Update a Workout object and save it to database
  Future<int> updateNote(Workouts workout) async {
    var db = await this.database;
    var result = await db.update(workoutTable, workout.toMap(), where: '$colId = ?', whereArgs: [workout.id]);
    return result;
  }

  // Fetch Operation: Get all Workout objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $workoutTable order by $colPriority ASC');
    var result = await db.query(workoutTable);
    return result;
  }

  // Get number of Workout objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $workoutTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Workouts>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Workouts> noteList = List<Workouts>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Workouts.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }



  Future<WorkoutExercises> upsertWorkoutExercises(WorkoutExercises workoutExercises) async {
    var count = Sqflite.firstIntValue(await _database.rawQuery("SELECT COUNT(*) FROM user WHERE username = ?", [workoutExercises.username]));
    if (count == 0) {
      workoutExercises.id = await _database.insert("workout_exercises", workoutExercises.toMap());
    } else {
      await _database.update("workout_exercises", workoutExercises.toMap(), where: "id = ?", whereArgs: [workoutExercises.id]);
    }
    return workoutExercises;
  }

  Future<WorkoutExercises> fetchUser(int id) async {
    List<Map> results = await _database.query("workout_exercises", columns: WorkoutExercises.columns, where: "id = ?", whereArgs: [id]);

    WorkoutExercises user = WorkoutExercises.fromMap(results[0]);

    return user;
  }

  Future<Workouts> fetchNoteAndUser(int noteId) async {
    List<Map> results = await _database.query(workoutTable, columns: Workouts.columns, where: "id = ?", whereArgs: [noteId]);

    Workouts note = Workouts.fromMapObject(results[0]);
    note.user = await fetchUser(note.id);

    return note;
  }
}
