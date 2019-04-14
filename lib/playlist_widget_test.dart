import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter_news_web/model/news.dart';
//import 'package:flutter_news_web/news_details.dart';
import 'package:http/http.dart' as http;


class PlaylistJSON {
  int id;
  String name;
  String imageURL;

  PlaylistJSON({
    this.id,
    this.name,
    this.imageURL
  });

  factory PlaylistJSON.fromJson(Map<String, dynamic> json) {
    return PlaylistJSON(
      id: json["id"],
      name: json["playlistName"],
      imageURL: json["description"],
    );
  }
}


class PlaylistTest extends StatefulWidget{
  List<PlaylistJSON> list;

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

}