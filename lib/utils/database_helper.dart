import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:fitness_tracker/models/workout_junction.dart';
import 'package:fitness_tracker/models/exercise.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  // Workout table
  String workoutTable = 'workout_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';

  // Workout exercises table
  String workoutExercisesTable = 'workout_junction_table';
  String colWorkoutExerciseId = 'id';
  String colWorkoutJunctionId = 'workout_junction_id';
  String colExerciseId = 'exercise_id';

  // Exercises table
  String exercisesTable = 'exercises_table';
  String colExercisesId = 'id';
  String colExercisesName = 'exercise_name';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  // Singleton object
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
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
    String path = directory.path + 'notes58.db';

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
              $colWorkoutExerciseId INTEGER PRIMARY KEY,
              username TEXT NOT NULL UNIQUE,
              $colExerciseId INTEGER,
              $colWorkoutJunctionId INTEGER,
              'FOREIGN KEY $colExerciseId REFERENCES $exercisesTable (id) ) '
      )''');
    await db.execute('''
          INSERT INTO $workoutExercisesTable
            ($colWorkoutExerciseId, username, $colExerciseId, $colWorkoutJunctionId)
          VALUES
            (1,"admin1",1,1),
            (2,"admin2",2,2),
            (3,"admin3",3,3),
            (4,"admin4",4,1),
            (5,"admin5",5,1)'''
    );

    // Exercise table
    await db.execute('''
      CREATE TABLE $exercisesTable (
        $colExercisesId INTEGER PRIMARY KEY, 
        $colExercisesName TEXT
    )''');
    await db.execute('''
          INSERT INTO $exercisesTable
            ($colExercisesId, $colExercisesName)
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

  Future<WorkoutJunction> upsertWorkoutExercises(WorkoutJunction workoutExercises) async {
    var count = Sqflite.firstIntValue(await _database.rawQuery("SELECT COUNT(*) FROM user WHERE username = ?", [workoutExercises.username]));
    if (count == 0) {
      workoutExercises.id = await _database.insert(workoutExercisesTable, workoutExercises.toMap());
    } else {
      await _database.update("workout_exercises_table", workoutExercises.toMap(), where: "id = ?", whereArgs: [workoutExercises.id]);
    }
    return workoutExercises;
  }

  // Fetch Workout exercise with specific id
  Future<WorkoutJunction> fetchWorkoutExercises(int id) async {
    List<Map> results = await _database.query(workoutExercisesTable, columns: WorkoutJunction.columns, where: "id = ?", whereArgs: [id]);
    WorkoutJunction workoutExercises = WorkoutJunction.fromMap(results[0]);
    return workoutExercises;
  }

  // Fetch
  Future<Workout> fetchWorkoutAndWorkoutExercises(int workoutId) async {
    List<Map> results = await _database.query(workoutTable, columns: Workout.columns, where: "id = ?", whereArgs: [workoutId]);
    Workout workouts = Workout.fromMapObject(results[0]);
    workouts.workoutExercises = await fetchWorkoutExercises(workouts.id);

    return workouts;
  }

  // Fetch all Exercise objects
  Future <List<Exercise>> fetchExercises() async {
    var result = await _database.rawQuery('SELECT * FROM $exercisesTable');
    List<Exercise> exercises = List<Exercise>();

    for(int  i= 0; i< result.length; i++){
      exercises.add(Exercise.fromMapObject(result[i]));
    }

    return exercises;
  }

}
