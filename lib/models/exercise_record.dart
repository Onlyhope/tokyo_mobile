import 'exercise_set.dart';

class ExerciseRecord {
  String workoutId;
  String exerciseRecId;
  String exerciseName;
  List<ExerciseSet> exerciseSets;
  DateTime createdDate;
  DateTime completedDate;

  ExerciseRecord(this.exerciseName, this.workoutId) {
    exerciseSets = [];
    createdDate = DateTime.now();
  }

  ExerciseRecord.value(
      {this.workoutId,
      this.exerciseRecId,
      this.exerciseName,
      this.exerciseSets,
      this.createdDate,
      this.completedDate});

  String nameAndCreatedDate() {
    return '$exerciseName -- ${createdDate.month}/${createdDate.day}';
  }

  ExerciseRecord.fromJson(Map<String, dynamic> json) {
    List<ExerciseSet> setList = [];
    var setsAsJson = json['sets'] as List;
    for (dynamic record in setsAsJson) {
      setList.add(ExerciseSet.fromJson(record));
    }

    this.exerciseRecId = json['ex_rec_id'];
    this.exerciseName = json['exercise_name'];
    this.exerciseSets = setList;
    this.createdDate = json['created_date'] != null
        ? DateTime.parse(json['created_date'])
        : null;
    this.completedDate = json['completed_date'] != null
        ? DateTime.parse(json['completed_date'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'exercise_name': exerciseName,
        'sets': exerciseSets,
        'created_date': createdDate.toString(),
        'compeleted_date': completedDate.toString()
      };

  @override
  String toString() {
    String exerciseSetsAsString = "";
    for (var x in this.exerciseSets) {
      exerciseSetsAsString += '${x}\n';
    }
    return 'ExerciseRecord{exerciseRecId: $exerciseRecId, exerciseName: $exerciseName}\n${exerciseSetsAsString}';
  }
}
