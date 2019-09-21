import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:fitness_tracker/utils/database_helper.dart';
import 'package:fitness_tracker/screens/workout_detail.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return WorkoutListState();
  }
}

class WorkoutListState extends State<WorkoutList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Workout> workoutList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (workoutList == null) {
      workoutList = List<Workout>();
      updateListView();
    }

    return Scaffold(

      //appBar: AppBar(
        //title: Text('Notes'),
      //),

      body: getNoteListView(),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Note('', '', 2), 'Add Note');
        },

        tooltip: 'Add Note',

        child: Icon(Icons.add),

      ),*/
    );
  }

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.play_arrow),
            ),
            title: Text(this.workoutList[position].name, style: titleStyle,),
            //subtitle: Text(this.workoutList[position].description),

            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.workoutList[position],this.workoutList[position].name);
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  void _delete(BuildContext context, Workout note) async {

    int result = await databaseHelper.deleteWorkout(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Workout note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WorkoutDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Workout>> workoutListFuture = databaseHelper.getWorkoutList();
      workoutListFuture.then((noteList) {
        setState(() {
          this.workoutList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
