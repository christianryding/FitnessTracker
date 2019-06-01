

class Exercise {

  int _id;
  String _exerciseName;

  static final columns = ["id", "exercise_name"];

  // Constructors
  Exercise(this._exerciseName);
  Exercise.withId(this._id, this._exerciseName);

  // Getters
  int get id => _id;
  String get exerciseName => _exerciseName;

  // Setters
  set exerciseName(String newExerciseNameTitle) {
    if (newExerciseNameTitle.length <= 255) {
      this._exerciseName = newExerciseNameTitle;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['exercise_name'] = _exerciseName;

    return map;
  }

  // Extract a Workout object from a Map object
  Exercise.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._exerciseName = map['exercise_name'];
  }
}


