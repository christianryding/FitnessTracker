import 'dart:async';
import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../database/database_client.dart';
import 'package:intl/intl.dart';
import '../database/user.dart';
import '../database/story.dart';

class PlaylistPage extends StatelessWidget {

  Future<Story> _test() async{
    DatabaseClient db = new DatabaseClient();
    await db.create();

    User user = new User();
    user.username = "admin";
    user = await db.upsertUser(user);
    Story story = new Story();
    story.title = "Breaking Story!";
    story.body = "Some great content...";
    story.user_id = user.id;
    story = await db.upsertStory(story);
    Story s = await db.fetchStoryAndUser(story.id);
    List<Story> latestStories = await db.fetchLatestStories(5);

    return s;
  }




  @override
  Widget build(BuildContext context) {


    return new Center(
      child: FutureBuilder(
        future: _test(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null){
            return Container(
              child: Center(
                child: Text("Loading"),
              ),
            );
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading: const Icon(Icons.transform),
                  title: Text(snapshot.data.length),//snapshot.data[index].id),
                  onTap: () {
                    print("Playlist id: " );
                  },
                );
              },
            );
          }
        },
      ),
    );




    return playlistPageState(context);
  }
}

Widget playlistPageState(BuildContext context)  {




  return new Center(
    child: Text('This is the home paaEEEaage!!!!....GIT'),
  );




}

