import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/home_widget.dart';

void main() => runApp(FitnessTracker());

/// Main class that build and runs application
class FitnessTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
