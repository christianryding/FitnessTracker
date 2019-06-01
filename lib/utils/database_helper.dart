import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/workout.dart';
import '../models/workout_exercises.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  // Workout table
  String workoutTable = 'workout_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';

  // Workout exercises table
  String workoutExercisesTable = 'workout_exercises_table';

  // Exercises table
  String exercisesTable = 'exercises_table';

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
    String path = directory.path + 'notes43.db';

    // Open/create the database at a given path
    var workoutsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return workoutsDatabase;
  }

  /*
  * Insert Values to database
  *
  *
  */
  void _createDb(Database db, int newVersion) async {

    // Table for Workouts
    await db.execute('''
      CREATE TABLE $workoutTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colTitle TEXT, 
        $colDescription TEXT, 
        'FOREIGN KEY ($colId) REFERENCES $workoutExercisesTable (id) ) '
    )''');
    await db.execute('''
          INSERT INTO $workoutTable
            ($colId, $colTitle,$colDescription)
          VALUES
            (1,"Summer PreWorkout", "Get ready for the beach!"),
            (2,"Winter PreWorkout", "Hmmmm...."),
            (3,"After Summer Workout", "Back at it!")'''
    );

    // Table for Workout exercises
    await db.execute('''
      CREATE TABLE $workoutExercisesTable (
              id INTEGER PRIMARY KEY,
              username TEXT NOT NULL UNIQUE,
              exerciseId INTEGER,
              workoutId INTEGER,
              'FOREIGN KEY exerciseId REFERENCES $exercisesTable (id) ) '
      )''');
    await db.execute('''
          INSERT INTO $workoutExercisesTable
            (id, username, exerciseId, workoutId)
          VALUES
            (1,"admin1",1,1),
            (2,"admin2",2,2),
            (3,"admin3",3,3),
            (4,"admin4",2,1),
            (5,"admin5",3,1)'''
    );

    // Exercise table
    await db.execute('''
      CREATE TABLE $exercisesTable (
        id INTEGER PRIMARY KEY, 
        exerciseName TEXT
    )''');
    await db.execute('''
          INSERT INTO $exercisesTable
            (id, exerciseName)
          VALUES
            (1,"PullUps"),
            (2,"Situps"),
            (3,"Chins"),
            (4,"Bench Press"),
            (5,"Treadmill"),
            (6,"Back"),
            (7,"Row")'''
    );
  }

  // Delete Operation: Delete a Workout object from database
  Future<int> deleteWorkout(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $workoutTable WHERE $colId = $id');
    return result;
  }

  // Insert Operation: Insert a Workout object to database
  Future<int> insertWorkout(Workout workout) async {
    Database db = await this.database;
    var result = await db.insert(workoutTable, workout.toMap());
    return result;
  }

  // Update Operation: Update a Workout object and save it to database
  Future<int> updateWorkout(Workout workout) async {
    var db = await this.database;
    var result = await db.update(workoutTable, workout.toMap(), where: '$colId = ?', whereArgs: [workout.id]);
    return result;
  }

  // Get number of Workout objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $workoutTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Fetch Operation: Get all Workout objects from database
  Future<List<Map<String, dynamic>>> getWorkoutMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $workoutTable order by $colPriority ASC');
    var result = await db.query(workoutTable);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Workout List' [ List<Workouts> ]
  Future<List<Workout>> getWorkoutList() async {
    var workoutMapList = await getWorkoutMapList(); // Get 'Map List' from database
    int count = workoutMapList.length;         // Count the number of map entries in db table
    List<Workout> workoutList = List<Workout>();

    // For loop to create a 'Workout List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      workoutList.add(Workout.fromMapObject(workoutMapList[i]));
    }
    return workoutList;
  }



  Future<WorkoutExercises> upsertWorkoutExercises(WorkoutExercises workoutExercises) async {
    var count = Sqflite.firstIntValue(await _database.rawQuery("SELECT COUNT(*) FROM user WHERE username = ?", [workoutExercises.username]));
    if (count == 0) {
      workoutExercises.id = await _database.insert(workoutExercisesTable, workoutExercises.toMap());
    } else {
      await _database.update("workout_exercises_table", workoutExercises.toMap(), where: "id = ?", whereArgs: [workoutExercises.id]);
    }
    return workoutExercises;
  }

  // Fetch Workout exercise with specific id
  Future<WorkoutExercises> fetchWorkoutExercises(int id) async {
    List<Map> results = await _database.query(workoutExercisesTable, columns: WorkoutExercises.columns, where: "id = ?", whereArgs: [id]);
    WorkoutExercises workoutExercises = WorkoutExercises.fromMap(results[0]);
    return workoutExercises;
  }

  // Fetch
  Future<Workout> fetchWorkoutAndWorkoutExercises(int workoutId) async {
    List<Map> results = await _database.query(workoutTable, columns: Workout.columns, where: "id = ?", whereArgs: [workoutId]);
    Workout workouts = Workout.fromMapObject(results[0]);
    workouts.workoutExercises = await fetchWorkoutExercises(workouts.id);

    return workouts;
  }
}
