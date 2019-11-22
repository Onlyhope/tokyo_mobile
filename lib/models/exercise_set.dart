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
}