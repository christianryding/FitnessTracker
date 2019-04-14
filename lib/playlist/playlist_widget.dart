import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Class to help retrieve playlist information
class PlaylistJSON {
  final int id;
  final String playlistName;
  final String imageURL;
  PlaylistJSON(this.id, this.playlistName, this.imageURL);
  String name(){
    return playlistName;
  }
}

class PlaylistTest extends StatefulWidget{  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<PlaylistTest>{
 
  Future<List<PlaylistJSON>> _getPlaylist() async {

    var data = await http.get("https://raw.githubusercontent.com/christianryding/FitnessTracker/master/lib/JSON/playlist_info.json");
    var jsonData = jsonDecode(data.body);
    List<PlaylistJSON> playlistArray = [];

    for(var u in jsonData){
      PlaylistJSON playlist = PlaylistJSON(u["id"], u["playlistName"], u["imageURL"]);
      playlistArray.add(playlist);
    }
    print(playlistArray.length);
    return playlistArray;
  } 



  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _getPlaylist(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            } else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: const Icon(Icons.transform),  
                      title: Text(snapshot.data[index].playlistName),
                      onTap: () { 
                        print("Playlist id: " + snapshot.data[index].id.toString());
                        },
                    );
                  },
                );
              }
          },
        ),
      ),
    );
  }
}





/*---------------------------------------------------*/

/// Returns list of available training sets
class PlaylistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return playlistListView(context);
  }
}

Widget playlistListView(BuildContext context) {

  return new Container(




  );
} 