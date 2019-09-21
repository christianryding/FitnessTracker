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

developer.log('log me', name: 'my.app.category');



  print();



  return new Center(
    child: Text('This is the log page!!!!'),
  );
}

void print() async{

DatabaseHelper db = new DatabaseHelper();

  List<Workout> workoutList = await db.getWorkoutList();
  for(int i = 0; i<workoutList.length; i++){
    Workout workout = workoutList[i];
    debugPrint("WorkoutId = " + workout.id.toString());
    debugPrint("WorkoutTitle = " + workout.title);
    debugPrint("WorkoutActive = " + workout.active.toString());
  }



} 