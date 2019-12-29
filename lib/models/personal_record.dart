class PersonalRecords {
  // All weights are taken in grams
  int squat;
  int bench;
  int deadLift;

  PersonalRecords({this.squat, this.bench, this.deadLift});

  @override
  String toString() {
    return 'PersonalRecords{squat: $squat, bench: $bench, deadLift: $deadLift}';
  }

}
