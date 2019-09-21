DROP TABLE IF EXISTS WorkoutTargets;
DROP TABLE IF EXISTS LogEntries;
DROP TABLE IF EXISTS WorkoutLog;
DROP TABLE IF EXISTS WorkoutCollection;
DROP TABLE IF EXISTS Exercises;
DROP TABLE IF EXISTS Workout;

CREATE TABLE Workout (
	WorkoutID INTEGER NOT NULL PRIMARY KEY,
	WorkoutName TEXT NOT NULL,
	WorkoutActive INTEGER NOT NULL
);

CREATE TABLE WorkoutCollection (
	WorkoutCollectionID INTEGER NOT NULL PRIMARY KEY,
	ExerciseID INTEGER NOT NULL,
	WorkoutID INTEGER NOT NULL,
      FOREIGN KEY (ExerciseId) REFERENCES Exercises(ExerciseID),
      FOREIGN KEY (WorkoutID) REFERENCES Workout(WorkoutID)
);

CREATE TABLE Exercises (
	ExerciseID INTEGER NOT NULL PRIMARY KEY,
	ExerciseName TEXT NOT NULL
);

CREATE TABLE WorkoutLog (
	WorkoutLogID INTEGER NOT NULL PRIMARY KEY,
	WorkoutID INTEGER NOT NULL,
	Date_Time TEXT,
      FOREIGN KEY (WorkoutID) REFERENCES Workout(WorkoutID)
);

CREATE TABLE LogEntries (
	LogEntriesID INTEGER NOT NULL PRIMARY KEY,
	LogID INTEGER NOT NULL,
	WorkoutCollectionID INTEGER NOT NULL,
	SetNumber INTEGER NOT NULL,
	WeightLogged  INTEGER NOT NULL,
	Reps INTEGER NOT NULL,
      FOREIGN KEY (LogID) REFERENCES WorkoutLog(WorkoutLogID),
      FOREIGN KEY (WorkoutCollectionID) REFERENCES WorkoutCollection(WorkoutCollectionID)
);

CREATE TABLE WorkoutTargets (
	WorkoutTargetsID INTEGER NOT NULL PRIMARY KEY,
	WorkoutCollectionID INTEGER NOT NULL,
	SetNumber INTEGER NOT NULL,
	MinReps INTEGER NOT NULL,
	MaxReps INTEGER NOT NULL,
    FOREIGN KEY (WorkoutCollectionID) REFERENCES WorkoutCollection(WorkoutCollectionID)
);

-- Workout
INSERT INTO  Workout (WorkoutID,WorkoutName,WorkoutActive) 
VALUES(1,'Program 1', 1);
INSERT  INTO Workout (WorkoutID,WorkoutName,WorkoutActive) 
VALUES(2,'Program 2', 0);
INSERT INTO Workout (WorkoutID,WorkoutName,WorkoutActive) 
VALUES(3,'Program 3', 0);
INSERT INTO Workout (WorkoutID,WorkoutName,WorkoutActive) 
VALUES(4,'Program 4', 0);

-- Exercises
INSERT INTO Exercises (ExerciseID,ExerciseName)
VALUES(1,"Pushups");
INSERT INTO Exercises (ExerciseID,ExerciseName)
VALUES(2,"Bench Press");
INSERT INTO Exercises (ExerciseID,ExerciseName)
VALUES(3,"Calves");
INSERT INTO Exercises (ExerciseID,ExerciseName)
VALUES(4,"Running");

-- Workout Collection
INSERT INTO WorkoutCollection (WorkoutCollectionID,ExerciseID,WorkoutID)
VALUES(1,1,1);
INSERT INTO WorkoutCollection (WorkoutCollectionID,ExerciseID,WorkoutID)
VALUES(2,2,1);
INSERT INTO WorkoutCollection (WorkoutCollectionID,ExerciseID,WorkoutID)
VALUES(3,3,1);

-- Workout Log
INSERT INTO WorkoutLog (WorkoutLogID,WorkoutID, Date_Time)
VALUES(1,1,"1_log for program 1");
INSERT INTO WorkoutLog (WorkoutLogID,WorkoutID, Date_Time)
VALUES(2,1,"2_log for program 11111");
INSERT INTO WorkoutLog (WorkoutLogID,WorkoutID, Date_Time)
VALUES(3,2,"3_log for program 2");

-- Log entries
INSERT INTO LogEntries (LogEntriesID,LogID, WorkoutCollectionID,SetNumber,WeightLogged,Reps)
VALUES(1,1,1,1,12,8);
INSERT INTO LogEntries (LogEntriesID,LogID, WorkoutCollectionID,SetNumber,WeightLogged,Reps)
VALUES(2,2,1,2,14,7);
INSERT INTO LogEntries (LogEntriesID,LogID, WorkoutCollectionID,SetNumber,WeightLogged,Reps)
VALUES(3,3,1,3,16,6);


-- Workout Targets
INSERT INTO WorkoutTargets (WorkoutTargetsID, WorkoutCollectionID, SetNumber, MinReps, MaxReps)
VALUES(1,1,3,8,8);
INSERT INTO WorkoutTargets (WorkoutTargetsID, WorkoutCollectionID, SetNumber, MinReps, MaxReps)
VALUES(2,2,3,8,10);
INSERT INTO WorkoutTargets (WorkoutTargetsID, WorkoutCollectionID, SetNumber, MinReps, MaxReps)
VALUES(3,3,3,8,12);

