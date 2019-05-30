import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/home_page.dart';
import 'package:fitness_tracker/screens/log_page.dart';
import '../screens/note_list.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

/// State for starting page
class HomeState extends State<Home> {
  int currentIndex = 0;

  /// Hold widgets for starting page
  final List<Widget> children = [
    HomePage(),
    LogPage(),
    NoteList(),
  ];

  /// Show current tab
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
              icon: Icon(Icons.playlist_add), title: Text('Playlist'))
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
