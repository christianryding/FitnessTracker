import 'package:flutter/material.dart';
import 'home_widget.dart';

void main() => runApp(FitnessTracker());

class FitnessTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
