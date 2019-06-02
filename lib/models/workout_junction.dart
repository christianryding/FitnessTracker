import 'dart:convert';
import 'exercise.dart';

class WorkoutJunction {

  WorkoutJunction();
  int id;
  String username;
  int exerciseId;
  int workoutId;
  List<Exercise> exercises;

  static final columns = ["id", "username", "exercise_id", "workout_junction_id"];

  Map toMap() {
    Map map = {
      "username": username,
      "exercise_id": exerciseId,
      "workout_junction_id": workoutId,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    WorkoutJunction workoutExercises = new WorkoutJunction();
    workoutExercises.id = map["id"];
    workoutExercises.username = map["username"];
    workoutExercises.exerciseId = map["exercise_id"];
    workoutExercises.workoutId = map["workout_junction_id"];

    return workoutExercises;
  }
}