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

  print();

  return new Center(
    child: Text('This is the log page!!!!'),
  );
}

void print() async{

  DatabaseHelper db = new DatabaseHelper();

  List<Exercise> list = await db.getExercisesFromActiveWorkout();
  for(int i = 0; i<list.length; i++){
    debugPrint("ExerciseName= " +list[i].exerciseName );
  }


  List<LogEntry> logEntriesList = await db.getLogEntriesList();
  for(int i = 0; i<logEntriesList.length; i++){
  //   LogEntry logEntry = logEntriesList[i];
  //   debugPrint("Log Entry ID= " + logEntry.id.toString());
  //   debugPrint("Log Entry Log Id = " + logEntry.logID.toString());
  //   debugPrint("Log Entry WC ID = " + logEntry.workoutCollectionID.toString());
  //   debugPrint("Log Entry Set Number = " + logEntry.setNumber.toString());
  //   debugPrint("Log Entry Weight Logged= " + logEntry.weightLogged.toString());
  //   debugPrint("Log Entry Reps = " + logEntry.reps.toString());
   }

} 