import 'dart:async';
import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../database/db_playlist.dart';
import 'package:intl/intl.dart';

class PlaylistPage extends StatelessWidget {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Playlist> playlistList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return playlistPageState(context);
  }
}

Widget playlistPageState(BuildContext context) {

  return new Center(
    child: Text('This is the home paaEEEaage!!!!'),
  );




}