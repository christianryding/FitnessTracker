import 'dart:async';
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../utils/database_helper.dart';
import 'package:intl/intl.dart';
import '../models/workout_exercises.dart';

class WorkoutDetail extends StatefulWidget {

  final String appBarTitle;
  final Workout workout;

  WorkoutDetail(this. workout, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return WorkoutDetailState(this.workout, this.appBarTitle);
  }
}

class WorkoutDetailState extends State<WorkoutDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Workout workouts;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  WorkoutDetailState(this.workouts, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = workouts.title;
    descriptionController.text = workouts.description;

    //_save();

    return WillPopScope(

        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                // First Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                              _print();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  /* TESTING */
  void _print()async{

    //Workouts note = new Workouts("Breaking Story!","Some great content...");
    //var note2 = await helper.insertWorkout(note);

    Workout note3 = await helper.fetchNoteAndUser(1);
    debugPrint("note 3 username = " + note3.workoutExercises.username);
    Workout note2 = await helper.fetchNoteAndUser(2);
    debugPrint("note 2 username = " + note2.workoutExercises.username);
    Workout note1 = await helper.fetchNoteAndUser(3);
    debugPrint("note 1 username = " + note1.workoutExercises.username);
  }
  /* TESTING */


  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void updateTitle(){
    workouts.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    workouts.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    int result;
    if (workouts.id != null) {  // Case 1: Update operation
      result = await helper.updateWorkout(workouts);
    } else { // Case 2: Insert Operation
      result = await helper.insertWorkout(workouts);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (workouts.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteWorkout(workouts.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
