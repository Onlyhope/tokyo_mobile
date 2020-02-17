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

    this.exerciseRecId = json['exerciseRecId'];
    this.exerciseName = json['exerciseName'];
    this.exerciseSets = setList;
    this.createdDate = json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'exerciseName': exerciseName,
        'sets': exerciseSets,
        'createdDate': createdDate.toString()
      };

  @override
  String toString() {
    String exerciseSetsAsString = "";
    for (var x in this.exerciseSets) {
      exerciseSetsAsString += '${x}\n';
    }
    return 'ExerciseRecord{exerciseRecId: $exerciseRecId, exerciseName: $exerciseName}\n$exerciseSetsAsString';
  }
}
