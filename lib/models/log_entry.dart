import 'dart:convert';

class LogEntry {

  LogEntry();
  int _id;
  int _logID;
  int _workoutCollectionID;
  int _setNumber;
  int _weightLogged;
  int _reps;

  static final columns = ["LogEntriesID", "LogID", "WorkoutCollectionID", "SetNumber, WeightLogged, Reps"];

  // Getters
  int get id => _id;
  int get logID => _logID;
  int get workoutCollectionID => _workoutCollectionID;
  int get setNumber => _setNumber;
  int get weightLogged => _weightLogged;
  int get reps => _reps;

  Map toMap() {
    Map map = {
      "LogID": _logID,
      "WorkoutCollectionID": _workoutCollectionID,
      "SetNumber": _setNumber,
      "WeightLogged": _weightLogged,
      "Reps": _reps,
    };

    if (_id != null) {
      map["LogEntriesID"] = _id;
    }

    return map;
  }

  static fromMapObject(Map map) {
    LogEntry logEntry = new LogEntry();
    logEntry._id = map["LogEntriesID"];
    logEntry._logID = map["LogID"];
    logEntry._workoutCollectionID = map["WorkoutCollectionID"];
    logEntry._setNumber = map["SetNumber"];
    logEntry._weightLogged = map["WeightLogged"];
    logEntry._reps = map["Reps"];

    return logEntry;
  }

}