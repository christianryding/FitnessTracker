import 'dart:async';
import 'package:flutter/material.dart';
import '../database/database_client.dart';
import 'package:intl/intl.dart';
import '../database/workout_playlist.dart';

class PlaylistPage extends StatefulWidget {

  @override
  State createState() => new PlaylistPageState();
}

class PlaylistPageState extends State<PlaylistPage> {

  final dbHelper = DatabaseHelper.instance;
  var _result;

  @override
  void initState() {

    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    _queryRows().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _result = result;
        _result.forEach((row) => print(row));
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      // This is what we show while we're loading
      return new Container(
       child: Text('Loading...'),
      );
    }
    else {
      // Do something with the `_result`s here
      _result.toString();
      return new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('insert', style: TextStyle(fontSize: 20),),
                onPressed: () {_insert();},
              ),
              RaisedButton(
                child: Text('query', style: TextStyle(fontSize: 20),),
                onPressed: () {_query();},
              ),
              RaisedButton(
                child: Text('update', style: TextStyle(fontSize: 20),),
                onPressed: () {_update();},
              ),
              RaisedButton(
                child: Text('delete', style: TextStyle(fontSize: 20),),
                onPressed: () {_delete();},
              ),
            ],
          ));
    }
  }


  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : 'Bob',
      DatabaseHelper.columnDesc  : 'asdasdsd'
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row[0]['title']));
  }

  Future<List<Map<String, dynamic>>> _queryRows() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row) => print(row));
    return allRows;
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId   : 1,
      DatabaseHelper.columnName : 'TestWorkout',
      DatabaseHelper.columnDesc : '#presummmer'
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

}
