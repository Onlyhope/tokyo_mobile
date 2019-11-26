import 'exercise_set.dart';

class ExerciseRecord {
  String exerciseRecId;
  String exerciseName;
  List<ExerciseSet> exerciseSets;
  DateTime createdDate;
  DateTime completedDate;

  ExerciseRecord(this.exerciseName) {
    exerciseSets = [];
    createdDate = DateTime.now();
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
    this.createdDate = json['created_date'];
    this.completedDate = json['completed_date'];
  }

  Map<String, dynamic> toJson() => {
    'exerciseRecId': exerciseRecId,
    'exerciseName': exerciseName,
    'sets': exerciseSets,
    'createdDate': createdDate.toString(),
    'completedDate': completedDate.toString()
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
