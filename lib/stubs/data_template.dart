import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/exercise_set.dart';
import 'package:uuid/uuid.dart';

class DataTemplate {
  Uuid uuid = Uuid();

  ExerciseRecord exerciseRecord(
      {String exRecId, String workoutId, DateTime createdDate}) {
    ExerciseRecord exerciseRecord = defaultExerciseRecord();
    exerciseRecord.exerciseRecId = exRecId;
    exerciseRecord.workoutId = workoutId;
    exerciseRecord.createdDate = createdDate;
    return exerciseRecord;
  }

  ExerciseRecord defaultExerciseRecord() {
    return ExerciseRecord.value(
        workoutId: uuid.v4(),
        exerciseRecId: uuid.v4(),
        exerciseName: 'Squat',
        exerciseSets: [],
        createdDate: DateTime.now(),
        completedDate: DateTime.now());
  }

  List<ExerciseRecord> exerciseRecords() {
    String workoutId = uuid.v4();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    return ['Squat', 'Bench', 'Pull Ups', 'Tricep Extensions', 'Dumbell Curls']
        .map((exerciseName) {
      ExerciseRecord mockRecord = ExerciseRecord(exerciseName, workoutId);
      mockRecord.createdDate = yesterday;
      mockRecord.exerciseSets = [
        ExerciseSet(135, 5),
        ExerciseSet(155, 8),
        ExerciseSet(175, 10)
      ];
      mockRecord.exerciseRecId = uuid.v4();
      return mockRecord;
    }).toList();
  }

  List<ExerciseRecord> monthOfExerciseRecords() {
    // Regular Case
    String clipsStartOfMonth = uuid.v4();
    String regularWorkout = uuid.v4();
    String clipsEndOfMonth = uuid.v4();

    List<ExerciseRecord> start = [
      DateTime.utc(2019, 10, 31, 23, 58, 30),
      DateTime.utc(2019, 11, 01, 00, 00, 00),
      DateTime.utc(2019, 11, 01, 00, 02, 30)
    ].map((date) {
      ExerciseRecord mockRecord = exerciseRecord(
          exRecId: uuid.v4(), workoutId: clipsStartOfMonth, createdDate: date);
      mockRecord.exerciseName = 'Bench';
      mockRecord.exerciseSets = [
        ExerciseSet(135, 5),
        ExerciseSet(155, 10),
        ExerciseSet(175, 10)
      ];
      return mockRecord;
    }).toList();

    List<ExerciseRecord> regularOne = [
      DateTime.utc(2019, 11, 15, 11, 54, 30),
      DateTime.utc(2019, 11, 15, 11, 58, 30),
      DateTime.utc(2019, 11, 15, 12, 00, 00),
      DateTime.utc(2019, 11, 15, 12, 03, 15),
      DateTime.utc(2019, 11, 15, 12, 07, 30)
    ].map((date) {
      ExerciseRecord mockRecord = exerciseRecord(
          exRecId: uuid.v4(), workoutId: regularWorkout, createdDate: date);
      mockRecord.exerciseName = 'Deadlift';
      mockRecord.exerciseSets = [
        ExerciseSet(135, 5),
        ExerciseSet(155, 10),
        ExerciseSet(175, 10)
      ];
      return mockRecord;
    }).toList();

    List<ExerciseRecord> regularTwo = [
      DateTime.utc(2019, 11, 17, 11, 54, 30),
      DateTime.utc(2019, 11, 17, 11, 58, 30),
      DateTime.utc(2019, 11, 17, 12, 00, 00),
      DateTime.utc(2019, 11, 17, 12, 03, 15),
      DateTime.utc(2019, 11, 17, 12, 07, 30)
    ].map((date) {
      ExerciseRecord mockRecord = exerciseRecord(
          exRecId: uuid.v4(), workoutId: regularWorkout, createdDate: date);
      mockRecord.exerciseName = 'Squat';
      mockRecord.exerciseSets = [
        ExerciseSet(135, 5),
        ExerciseSet(155, 10),
        ExerciseSet(175, 10)
      ];
      return mockRecord;
    }).toList();

    List<ExerciseRecord> end = [
      DateTime.utc(2019, 11, 30, 23, 58, 30),
      DateTime.utc(2019, 12, 01, 00, 00, 00),
      DateTime.utc(2019, 12, 01, 00, 02, 30)
    ].map((date) {
      ExerciseRecord mockRecord = exerciseRecord(
          exRecId: uuid.v4(), workoutId: clipsEndOfMonth, createdDate: date);
      mockRecord.exerciseName = 'Military Press';
      mockRecord.exerciseSets = [
        ExerciseSet(135, 5),
        ExerciseSet(155, 10),
        ExerciseSet(175, 10)
      ];
      return mockRecord;
    }).toList();

    return start + regularOne + regularTwo + end;
  }
}
