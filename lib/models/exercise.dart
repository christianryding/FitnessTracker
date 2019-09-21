

class Exercise {
  int _id;
  String _exerciseName;

  static final columns = ["ExerciseID", "ExerciseName"];

  // Constructors
  Exercise(this._exerciseName);
  Exercise.withId(this._id, this._exerciseName);

  // Getters
  int get id => _id;
  String get exerciseName => _exerciseName;

  // Setters
  set exerciseName(String newExerciseName) {
    if (newExerciseName.length <= 255) {
      this._exerciseName = newExerciseName;
    }
  }

  // Convert a Exercise object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['ExerciseID'] = _id;
    }
    map['ExerciseName'] = _exerciseName;

    return map;
  }

  // Extract a Exercise object from a Map object
  Exercise.fromMapObject(Map<String, dynamic> map) {
    this._id = map['ExerciseID'];
    this._exerciseName = map['ExerciseName'];
  }
}


