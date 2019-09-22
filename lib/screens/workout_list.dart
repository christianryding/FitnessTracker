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
  
   DatabaseHelper db= new DatabaseHelper();
  int _selectedRadio;

 @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      body: futureBuilder,
    );
  }

  Future<List<Workout>> _getData() async {
    List<Workout> workoutList = await db.getWorkoutList();
    return workoutList;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Workout> values = snapshot.data;

    return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {

          if(values[index].active == 1){
            _selectedRadio = values[index].id;        
          }
          return new Column(
            children: <Widget>[
              new RadioListTile(
                title: new Text(values[index].name),
                value:  values[index].id,

                groupValue: _selectedRadio,
                activeColor: Colors.cyan,
                  onChanged: (val) {
                    print("Radio " + values[index].id.toString());
                    setSelectedRadio(val);
                    //updateDb();
                  },
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
    );
  }

void updateDb(int oldID, int newID){
  
  // query so active disappear and new sets 
}

  // Changes the selected value on 'onChanged' click on each radio button
void setSelectedRadio(int val) {
  setState(() {
    _selectedRadio = val;
  });
}









  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
