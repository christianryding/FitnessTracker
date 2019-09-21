import 'dart:convert';

class LogEntry {

  LogEntry();
  int id;
  int logID;
  int workoutCollectionID;
  int setNumber;
  int weightLogged;
  int reps;

  static final columns = ["id", "log_id", "workout_collection_id", "set_number, weight_logged, reps"];

  // Getters
  int get weight_logged => weightLogged;

  Map toMap() {
    Map map = {
      "log_id": logID,
      "workout_collection_id": workoutCollectionID,
      "set_number": setNumber,
      "weight_logged": weightLogged,
      "reps": reps,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    LogEntry logEntry = new LogEntry();
    logEntry.id = map["id"];
    logEntry.logID = map["logID"];
    logEntry.workoutCollectionID = map["workout_collection_id"];
    logEntry.setNumber = map["set_number"];
    logEntry.weightLogged = map["weight_logged"];
    logEntry.reps = map["reps"];

    return logEntry;
  }

}