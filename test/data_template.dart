import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:uuid/uuid.dart';

class DataTemplate {

  ExerciseRecord exerciseRecord({String exRecId, String workoutId, DateTime createdDate}) {
    ExerciseRecord exerciseRecord = defaultExerciseRecord();
    exerciseRecord.exerciseRecId = exRecId;
    exerciseRecord.workoutId = workoutId;
    exerciseRecord.createdDate = createdDate;
    return exerciseRecord;
  }

  ExerciseRecord defaultExerciseRecord() {
    return ExerciseRecord.value(
      workoutId: Uuid().v4(),
      exerciseRecId: "1",
      exerciseName: "Squat",
      exerciseSets: [],
      createdDate: DateTime.now(),
      completedDate: DateTime.now()
    );
  }




}