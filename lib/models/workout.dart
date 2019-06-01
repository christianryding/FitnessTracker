import 'workout_exercises.dart';

class Workout {

  int _id;
  String _workoutTitle;
  String _workoutDescription;
  WorkoutExercises workoutExercises;

  static final columns = ["id", "title", "description"];

  // Constructors
  Workout(this._workoutTitle, [this._workoutDescription]);
  Workout.withId(this._id, this._workoutTitle, [this._workoutDescription]);

  // Getters
  int get id => _id;
  String get title => _workoutTitle;
  String get description => _workoutDescription;

  // Setters
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._workoutTitle = newTitle;
    }
  }
  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._workoutDescription = newDescription;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _workoutTitle;
    map['description'] = _workoutDescription;

    return map;
  }

  // Extract a Workout object from a Map object
  Workout.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._workoutTitle = map['title'];
    this._workoutDescription = map['description'];
  }
}


