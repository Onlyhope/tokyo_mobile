import 'exercise_record.dart';

class WorkoutRecord {

  List<ExerciseRecord> exerciseRecords;
  DateTime startDate;
  DateTime endDate;

  WorkoutRecord({this.exerciseRecords, this.startDate, this.endDate});

  @override
  String toString() {
    return 'WorkoutRecord{exerciseRecords: $exerciseRecords, startDate: $startDate, endDate: $endDate}';
  }


}