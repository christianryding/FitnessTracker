import 'dart:convert';
import 'exercise.dart';

class WorkoutExercises {

  WorkoutExercises();
  int id;
  String username;
  int exerciseId;
  int workoutId;
  List<Exercise> exercises;

  static final columns = ["id", "username", "exerciseId", "workoutId"];

  Map toMap() {
    Map map = {
      "username": username,
      "exerciseId": exerciseId,
      "workoutId": workoutId,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    WorkoutExercises workoutExercises = new WorkoutExercises();
    workoutExercises.id = map["id"];
    workoutExercises.username = map["username"];
    workoutExercises.exerciseId = map["exerciseId"];
    workoutExercises.workoutId = map["workoutId"];

    return workoutExercises;
  }
}