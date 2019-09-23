import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:fitness_tracker/models/log_entry.dart';
import 'package:fitness_tracker/models/exercise.dart';
import 'package:fitness_tracker/models/workout.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

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
    //Directory directory = await getApplicationDocumentsDirectory();
    //String path = directory.path + 'notes69.db';

    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes78.db');

    // Open/create the database at a given path
    var workoutsDatabase = await openDatabase(path, version: 1, onCreate: _createDb);

    return workoutsDatabase;
  }

  /*
  * Insert Values to database
  */
  void _createDb(Database db, int newVersion) async {


  // Workout table
  await db.execute("CREATE TABLE Workout (WorkoutID INTEGER NOT NULL PRIMARY KEY, WorkoutName TEXT NOT NULL, WorkoutActive  INTEGER NOT NULL)" );
  // Workout Collection table
  await db.execute("CREATE TABLE WorkoutCollection (WorkoutCollectionID INTEGER NOT NULL PRIMARY KEY,	ExerciseID INTEGER NOT NULL,	WorkoutID INTEGER NOT NULL,   FOREIGN KEY (ExerciseId) REFERENCES Exercises(ExerciseID), FOREIGN KEY (WorkoutID) REFERENCES Workout(WorkoutID))");
  // Exercises table
  await db.execute("CREATE TABLE Exercises (ExerciseID INTEGER NOT NULL PRIMARY KEY, ExerciseName TEXT NOT NULL)");
  // Workout Log table
  await db.execute("CREATE TABLE WorkoutLog (WorkoutLogID INTEGER NOT NULL PRIMARY KEY, WorkoutID INTEGER NOT NULL, Date_Time TEXT, FOREIGN KEY (WorkoutID) REFERENCES Workout(WorkoutID) )");
  // Log Entries table
  await db.execute("CREATE TABLE LogEntries (LogEntriesID INTEGER NOT NULL PRIMARY KEY, LogID INTEGER NOT NULL, WorkoutCollectionID INTEGER NOT NULL, SetNumber INTEGER NOT NULL, WeightLogged  INTEGER NOT NULL, Reps INTEGER NOT NULL, FOREIGN KEY (LogID) REFERENCES WorkoutLog(WorkoutLogID), FOREIGN KEY (WorkoutCollectionID) REFERENCES WorkoutCollection(WorkoutCollectionID) )");
  // Workout Targets table
  await db.execute("CREATE TABLE WorkoutTargets (WorkoutTargetsID INTEGER NOT NULL PRIMARY KEY,	WorkoutCollectionID INTEGER NOT NULL,SetNumber INTEGER NOT NULL,MinReps INTEGER NOT NULL,	MaxReps INTEGER NOT NULL,    FOREIGN KEY (WorkoutCollectionID) REFERENCES WorkoutCollection(WorkoutCollectionID) )");

    await db.execute('''
          INSERT INTO Workout
            (WorkoutID, WorkoutName, WorkoutActive)
          VALUES
            (1,'Program 1', 1),
            (2,'Program 2', 0),
            (3,'Program 3', 0),
            (4,'Program 4', 0)
            '''
    );
    await db.execute('''
          INSERT INTO  WorkoutCollection (WorkoutCollectionID,ExerciseID,WorkoutID)
          VALUES
            (1,1,1),
            (2,2,1),
            (3,3,1)
            '''
    );
    await db.execute('''
          INSERT INTO Exercises (ExerciseID,ExerciseName)
          VALUES
            (1,"Pushups"),
            (2,"Pushups"),
            (3,"Calves"),
            (4,"Running")
            '''
    );
    await db.execute('''
      INSERT INTO WorkoutLog (WorkoutLogID,WorkoutID, Date_Time)
        VALUES
        (1, 1, "1_log for program 1"),
        (2, 1, "2_log for program 11111"),
        (3, 2, "3_log for program 2")
        '''
     );
    await db.execute('''
      INSERT INTO LogEntries (LogEntriesID,LogID, WorkoutCollectionID,SetNumber,WeightLogged,Reps)
        VALUES
        (1,1,1,1,12,8),
        (2,2,1,2,14,7),
        (3,3,1,3,16,6)
        '''
     );
    await db.execute('''
      INSERT INTO WorkoutTargets (WorkoutTargetsID, WorkoutCollectionID, SetNumber, MinReps, MaxReps)
        VALUES
        (1,1,3,8,8),
        (2,2,3,8,10),
        (3,3,3,8,12)
        '''
     );
}

  // Get the 'Map List' [ List<Map> ] and convert it to 'Workout List' [ List<Workouts> ]
Future<List<Workout>> getWorkoutList() async {

  Database db = await this.database;

  // get workout map list
  var workoutMapList = await db.query("Workout");
  int count = workoutMapList.length;
  List<Workout> workoutList = List<Workout>();

  // For loop to create a 'Workout List' from a 'Map List'
  for (int i = 0; i < count; i++) {
    workoutList.add(Workout.fromMapObject(workoutMapList[i]));
  }
  return workoutList;
}


  // Get the 'Map List' [ List<Map> ] and convert it to 'Exercise List' [ List<Exercise> ]
  Future<List<Exercise>> getExercisesList() async {

    Database db = await this.database;

    // get workout map list
    var exercisesMapList = await db.query("Exercises");

    int count = exercisesMapList.length;
    List<Exercise> exercisesList = List<Exercise>();

    // For loop to create a 'Workout List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      exercisesList.add(Exercise.fromMapObject(exercisesMapList[i]));
    }
    return exercisesList;
  }


  // Get the 'Map List' [ List<Map> ] and convert it to 'Log Entry List' [ List<LogEntry> ]
  Future<List<LogEntry>> getLogEntriesList() async {

    Database db = await this.database;

    // get Log Entries map list
    //var logEntriesMapList = await db.query("LogEntries");
    var logEntriesMapList = await db.query('LogEntries', columns: ['SetNumber', 'Reps'], where: '"WorkoutCollectionID" = ?', whereArgs: [1]);

    int count = logEntriesMapList.length;
    List<LogEntry> logEntriesList = List<LogEntry>();

    // For loop to create a 'Workout List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      logEntriesList.add(LogEntry.fromMapObject(logEntriesMapList[i]));
    }
    return logEntriesList;
  }



Future<int> setActiveProgram(int newID) async{
  
  Database db = await this.database;
  var updateTable = await db.rawUpdate('''
    UPDATE Workout 
    SET WorkoutActive = ? 
    WHERE WorkoutActive = ?
    ''', 
    [0,1]); 
   
  updateTable = await db.rawUpdate('''
    UPDATE Workout 
    SET WorkoutActive = ? 
    WHERE WorkoutID = ?
    ''', 
    [1,newID]);     
  
  //TODO - fix return statement  
  return 3;
 }


Future<List<Exercise>> getExercisesFromActiveWorkout()async{
  
  Database db = await this.database;
  int active = 1;

  // Fetch active Workout 
  List<Map> results = await _database.query('Workout', columns:['WorkoutID'], where: "WorkoutActive = ?", whereArgs: [active]);
  Workout  workoutId = Workout.fromMapObject(results[0]);

  // Fetch exercises id
  List<Map> exerciseIdList = await _database.query('WorkoutCollection', columns:['ExerciseID'], where: "WorkoutID = ?", whereArgs: [workoutId.id]);
  int count = exerciseIdList.length;
  debugPrint("count: " + count.toString()); 

  // Fetch names of exercises 
  List<Map> test = await _database.rawQuery('''
    SELECT ExerciseID, ExerciseName
    FROM Exercises 
    WHERE ExerciseID IN (1, 2, 3) 
    '''
  );



  Exercise exercise = Exercise.fromMapObject(test[0]);
  debugPrint("test: " + exercise.exerciseName); 
    Exercise exercise2 = Exercise.fromMapObject(test[1]);
  debugPrint("test: " + exercise2.exerciseName); 
    Exercise exercise3 = Exercise.fromMapObject(test[2]);
  debugPrint("test: " + exercise3.exerciseName); 
  //exerciseIDs.add(Exercise.fromMapObject(exerciseNameList[0]));
  //debugPrint("test: " + exerciseIDs[0].exerciseName);




 List<Exercise> s = new List<Exercise>();
  return s;
}


  

}// DatabaseHelper