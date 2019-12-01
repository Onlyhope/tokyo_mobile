class ExerciseSet {
  int setId;
  int exerciseRecId;
  int reps;
  int weight;
  DateTime createdDate;

  ExerciseSet(this.weight, this.reps);

  ExerciseSet.fromJson(Map<String, dynamic> json)
      : weight = json['weight'],
        reps = json['reps'];

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'reps': reps,
    };
  }

  @override
  String toString() {
    return 'ExerciseSet{reps: $reps, weight: $weight}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExerciseSet &&
              runtimeType == other.runtimeType &&
              exerciseRecId == other.exerciseRecId &&
              reps == other.reps &&
              weight == other.weight &&
              createdDate == other.createdDate;

  @override
  int get hashCode =>
      exerciseRecId.hashCode ^
      reps.hashCode ^
      weight.hashCode ^
      createdDate.hashCode;




}