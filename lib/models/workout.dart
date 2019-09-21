class Workout {

  int _id;
  String _name;
  int _active;

  static final columns = ["WorkoutID", "WorkoutName", "WorkoutActive"];

  // Constructors
  Workout(this._name,this._active);
  Workout.withId(this._id, this._name, this._active);

  // Getters
  int get id => _id;
  String get name => _name;
  int get active => _active;

  // Setters
  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }
  set active(int newActive) {
    this._active = newActive;
  }

  // Convert a Workout object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['WorkoutID'] = _id;
    }
    map['WorkoutName'] = _name;
    map['WorkoutActive'] = _active;

    return map;
  }

  // Extract a Workout object from a Map object
  Workout.fromMapObject(Map<String, dynamic> map) {
    this._id = map['WorkoutID'];
    this._name = map['WorkoutName'];
    this._active = map['WorkoutActive'];
  }
}


