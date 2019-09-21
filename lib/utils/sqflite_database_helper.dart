import 'package:fitness_tracker/models/workout.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//import 'package:fitness_tracker/models/workout.dart';
import 'package:fitness_tracker/models/log_entry.dart';
import 'package:fitness_tracker/models/workout_junction.dart';
import 'package:fitness_tracker/models/exercise.dart';

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
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes69.db';

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
  await db.execute("CREATE TABLE Exercises (ExerciseID INTEGER NOT NULL PRIMARY KEY, ExerciseName TEXT NOT NULL )");
  // Workout Log table
  //await db.execute("CREATE TABLE WorkoutLog (WorkoutLogID INTEGER NOT NULL PRIMARY KEY,	WorkoutID INTEGER NOT NULL,	Date_Time TEXT, FOREIGN KEY (WorkoutID) REFERENCES Workout(WorkoutID)");
  // Log Entries table
  //await db.execute("CREATE TABLE LogEntries (	LogEntriesID INTEGER NOT NULL PRIMARY KEY, LogID INTEGER NOT NULL, WorkoutCollectionID INTEGER NOT NULL, SetNumber INTEGER NOT NULL, WeightLogged  INTEGER NOT NULL, Reps INTEGER NOT NULL, FOREIGN KEY (LogID) REFERENCES WorkoutLog(WorkoutLogID), FOREIGN KEY (WorkoutCollectionID) REFERENCES WorkoutCollection(WorkoutCollectionID)");
  // Workout Targets table
    //await db.execute("CREATE TABLE WorkoutTargets (WorkoutTargetsID INTEGER NOT NULL PRIMARY KEY,	WorkoutCollectionID INTEGER NOT NULL,SetNumber INTEGER NOT NULL,MinReps INTEGER NOT NULL,	MaxReps INTEGER NOT NULL,    FOREIGN KEY (WorkoutCollectionID) REFERENCES WorkoutCollection(WorkoutCollectionID)");

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

    //     await db.execute('''
    //       INSERT INTO WorkoutLog (WorkoutLogID,WorkoutID, Date_Time)
    //       VALUES
    //         (1,1,"1_log for program 1"),
    //        (2,1,"2_log for program 11111"),
    //        (3,2,"3_log for program 2")
    //         '''
    // );

    //         await db.execute('''
    //       INSERT INTO LogEntries (LogEntriesID,LogID, WorkoutCollectionID,SetNumber,WeightLogged,Reps)
    //       VALUES
    //         (1,1,1,1,12,8),
    //       (2,2,1,2,14,7),
    //        (3,3,1,3,16,6)
    //         '''
    // );


    //             await db.execute('''
    //       INSERT INTO WorkoutTargets (WorkoutTargetsID, WorkoutCollectionID, SetNumber, MinReps, MaxReps)
    //       VALUES
    //         (1,1,3,8,8),
    //       (2,2,3,8,10),
    //        (3,3,3,8,12)
    //         '''
    // );


}

  
  // Fetch Operation: Get all Workout objects from database
  Future<List<Map<String, dynamic>>> getWorkoutMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $workoutTable order by $colPriority ASC');
    var result = await db.query("Workout");
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
  
  

}