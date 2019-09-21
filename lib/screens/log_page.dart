import 'package:fitness_tracker/models/exercise.dart';
import 'package:fitness_tracker/models/log_entry.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:flutter/material.dart';

import 'package:fitness_tracker/utils/sqflite_database_helper.dart';
import 'dart:developer' as developer;

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return logPageState(context);
  }
}

Widget logPageState(BuildContext context) {

  print();//debugging

  return new Center(
    child: Text('This is the log page!!!!'),
  );
}

void print() async{

DatabaseHelper db = new DatabaseHelper();

/*
  List<Workout> workoutList = await db.getWorkoutList();
  for(int i = 0; i<workoutList.length; i++){
    Workout workout = workoutList[i];
    debugPrint("Workout Id = " + workout.id.toString());
    debugPrint("Workout Name = " + workout.title);
    debugPrint("Workout Active = " + workout.active.toString());
  }

  List<Exercise> exercisesList = await db.getExercisesList();
  for(int i = 0; i<exercisesList.length; i++){
    Exercise exercise = exercisesList[i];
    debugPrint("Exercise Id = " + exercise.id.toString());
    debugPrint("Exercise Name = " + exercise.exerciseName);
  }
*/

  List<LogEntry> logEntriesList = await db.getLogEntriesList();
  /*for(int i = 0; i<logEntriesList.length; i++){
    LogEntry logEntry = logEntriesList[i];
    debugPrint("Log Entry ID= " + logEntry.id.toString());
    debugPrint("Log Entry Log Id = " + logEntry.logID.toString());
    debugPrint("Log Entry WC ID = " + logEntry.workoutCollectionID.toString());
    debugPrint("Log Entry Set Number = " + logEntry.setNumber.toString());
    debugPrint("Log Entry Weight Logged= " + logEntry.weightLogged.toString());
    debugPrint("Log Entry Reps = " + logEntry.reps.toString());
  }
  */






} 