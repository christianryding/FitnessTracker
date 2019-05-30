import 'package:flutter/material.dart';
import './home/home_widget.dart';

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
