import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'playlist_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

/*  
  State for starting page
 */
class HomeState extends State<Home> {
  int currentIndex = 0;
  /// Holds
  final List<Widget> children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.blueAccent),
    PlaylistWidget(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Tracker'),
      ),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex, 
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add),
            title: new Text('Log'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add),
              title: Text('Playlist')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}