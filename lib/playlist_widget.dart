import 'package:flutter/material.dart';
   
class PlaylistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return playlistListView(context);
  }
}

Widget playlistListView(BuildContext context) {
  return ListView(
    children: ListTile.divideTiles(
      context: context,
      tiles: [
        ListTile(
          title: Text('Sun'),
        ),
        ListTile(
          title: Text('Moon'),
        ),
        ListTile(
          title: Text('Star'),
        ),
      ],
    ).toList(),
  );
}