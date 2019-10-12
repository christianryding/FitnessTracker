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


  return new Scaffold(

        backgroundColor: Colors.white,
        body: new Container(
            padding: const EdgeInsets.all(40.0),
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: "Enter your number"),
              keyboardType: TextInputType.number,
            ),
            new TextField(
              decoration: new InputDecoration(labelText: "Enter your number"),
              keyboardType: TextInputType.number,
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget> [

                Expanded(
                  child: Text('ActivityName', textAlign: TextAlign.left),
                ),
                Expanded(
                  child: TextField(
                          //decoration: new InputDecoration(labelText: "Log"),
                          keyboardType: TextInputType.number,
                          textAlign:  TextAlign.center,
                        ),
                ),
                  Expanded(
                    child: new RaisedButton(
                      child: new Text("Log"),
                      color: Colors.red,
                      onPressed: () => logBtnPressed(4),
                    ),
                  ),

              ],
            ),
          ],  
        )
        ),
      );
}

void logBtnPressed(int w){
debugPrint(w.toString());
}

void print() async{

  DatabaseHelper db = new DatabaseHelper();

  List<Exercise> list = await db.getExercisesFromActiveWorkout();
  //for(int i = 0; i<list.length; i++){
    //debugPrint("ExerciseName= " +list[i].exerciseName );
  //}


} 