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
  Future<List<Map<String, dynamic>>> list = db.getWorkoutMapList();


    List<Workout> workoutList = await db.getWorkoutList();
    for(int i = 0; i<workoutList.length; i++){
      Workout workout = workoutList[i];

      // Workout object
      debugPrint("WorkoutId = " + workout.id.toString());
      debugPrint("WorkoutTitle = " + workout.title);
      //debugPrint("WorkoutDesc = " + workout.);

      // WorkoutExercises object
      //debugPrint("username = " + workout.workoutExercises.username);
      //debugPrint("id = " + workout.workoutExercises.id.toString());
      //debugPrint("exerciseId = " + workout.workoutExercises.exerciseId.toString());
      //debugPrint("workoutId = " + workout.workoutExercises.workoutId.toString());
    }



} 