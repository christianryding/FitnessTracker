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
                      title: Text(snapshot.data[index].playlistName),
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

  
  
/*   List<PlaylistJSON> list;
  Future<List<PlaylistJSON>> getData(String newsType) async {
    String link =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=API_KEY";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    print(res.body);

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["articles"] as List;
      print(rest);
      list = rest.map<PlaylistJSON>((json) => PlaylistJSON.fromJson(json))
          .toList();
    }

    print("List Size: ${list.length}");
    return list;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("sadsadsadsa");
    return null;
  }

} */