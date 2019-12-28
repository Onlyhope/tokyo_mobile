import 'exercise_record.dart';

class WorkoutRecord {

  List<ExerciseRecord> exerciseRecords;
  DateTime startDate;
  DateTime endDate;

  WorkoutRecord({this.exerciseRecords, this.startDate, this.endDate});

  WorkoutRecord.fromExerciseRecords({this.exerciseRecords}) {
    this.startDate = this.exerciseRecords.first.createdDate;
    this.endDate = this.exerciseRecords.last.createdDate;
  }

  @override
  String toString() {
    return 'WorkoutRecord{exerciseRecords: $exerciseRecords, startDate: $startDate, endDate: $endDate}';
  }


}