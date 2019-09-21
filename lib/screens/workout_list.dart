import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:fitness_tracker/utils/sqflite_database_helper.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return WorkoutListState();
  }
}

class WorkoutListState extends State<WorkoutList> {

  int groupValue = 1;
  DatabaseHelper dbHelper = new DatabaseHelper();
  List<Workout> workoutList;
  int count;

  @override
  Widget build(BuildContext context) {

    if (workoutList == null) {
      workoutList = List<Workout>();
      updateListView();

    }

    return getNoteListView();
  }

  /*void getActive()async{
    groupValue = await dbHelper.getActiveProgram();
  }

   */



  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    //getActive();

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return new RadioListTile(

          //title: Text("ADasd"),
          title: Text(this.workoutList[position].name, style: titleStyle),

            value: workoutList[position].id,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                groupValue = value;
                debugPrint("id = " + value.toString());
              });
            },
        );
      },
    );
  }



  void _delete(BuildContext context, Workout note) async {

    /*int result = await databaseHelper.deleteWorkout(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
    */
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }


  void updateListView() {

    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Workout>> workoutListFuture = dbHelper.getWorkoutList();
      workoutListFuture.then((list) {
        setState(() {
          this.workoutList = list;
          this.count = list.length;
        });
      });
    });
  }
}
